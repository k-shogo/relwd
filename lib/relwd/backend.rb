module Relwd
  class Backend < Base

    def add(doc, opts = {})
      opts = { skip_duplicate_check: false }.merge(opts)
      document_validate doc
      id = document_id doc

      remove(id: id) unless opts[:skip_duplicate_check]

      Relwd.redis.pipelined do
        Relwd.redis.hset(database, id, MultiJson.encode(doc))
        prefixes_for_phrase(document_to_phrase(doc)).each do |p|
          Relwd.redis.zadd(base_and(p), document_score(doc), id)
        end
      end
    end

    def remove(doc)
      if prev_doc = Relwd.redis.hget(database, document_id(doc))
        prev_doc = MultiJson.decode(prev_doc)
        prev_id = document_id prev_doc
        Relwd.redis.pipelined do
          Relwd.redis.hdel(database, prev_id)
          prefixes_for_phrase(document_to_phrase(prev_doc)).each do |p|
            Relwd.redis.zrem(base_and(p), prev_id)
          end
        end
      end
    end

  end
end
