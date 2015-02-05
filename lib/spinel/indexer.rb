module Spinel
  module Indexer

    def store doc, opts = {}
      opts = { skip_duplicate_check: false }.merge(opts)
      id, body, score = get_valid_document doc

      remove(id: id) unless opts[:skip_duplicate_check]

      Spinel.redis.pipelined do
        Spinel.redis.hset(database, id, MultiJson.encode(doc))
        prefixes(body).each do |p|
          Spinel.redis.zadd(index(p), score, id)
        end
      end
      doc
    end

    def get id
      if doc = Spinel.redis.hget(database, id)
        MultiJson.decode(doc)
      end
    end

    def remove doc
      if prev_doc = Spinel.redis.hget(database, document_id(doc))
        prev_doc = MultiJson.decode(prev_doc)
        prev_id = document_id prev_doc
        Spinel.redis.pipelined do
          Spinel.redis.hdel(database, prev_id)
          prefixes(document_index_fields(prev_doc)).each do |p|
            Spinel.redis.zrem(index(p), prev_id)
          end
        end
      end
    end

  end
end
