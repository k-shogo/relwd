module Relwd
  class Backend < Base

    def import(items)
      phrases = Relwd.redis.smembers(base)
      Relwd.redis.pipelined do
        phrases.each {|p| Relwd.redis.del(base_and(p))}
        Relwd.redis.del(base)
      end

      Relwd.redis.del(database)
      items.each {|item| add(item, skip_duplicate_check: true)}
    end

    def add(item, opts = {})
      opts = { skip_duplicate_check: false }.merge(opts)
      item_validate item
      id = item_id item

      remove("id" => id) unless opts[:skip_duplicate_check]

      Relwd.redis.pipelined do
        Relwd.redis.hset(database, id, MultiJson.encode(item))
        phrase = item_to_phrase item
        prefixes_for_phrase(phrase).each do |p|
          Relwd.redis.sadd(base, p)
          Relwd.redis.zadd(base_and(p), item_score(item), id)
        end
      end
    end

    def remove(item)
      id = item_id item
      prev_item = Relwd.redis.hget(database, id)
      if prev_item
        prev_item = MultiJson.decode(prev_item)
        prev_id = item_id prev_item
        Relwd.redis.pipelined do
          Relwd.redis.hdel(database, prev_id)
          phrase = item_to_phrase item
          prefixes_for_phrase(phrase).each do |p|
            Relwd.redis.srem(base, p)
            Relwd.redis.zrem(base_and(p), prev_id)
          end
        end
      end
    end

  end
end
