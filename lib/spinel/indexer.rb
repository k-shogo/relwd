module Spinel
  module Indexer

    def store doc, opts = {}
      opts = { skip_duplicate_check: false }.merge(opts)
      document_validate doc
      id = document_id doc

      remove(id: id) unless opts[:skip_duplicate_check]

      Spinel.redis.pipelined do
        Spinel.redis.hset(database, id, MultiJson.encode(doc))
        prefixes_for_phrase(document_body(doc)).each do |p|
          Spinel.redis.zadd(index(p), document_score(doc), id)
        end
      end
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
          prefixes_for_phrase(document_body(prev_doc)).each do |p|
            Spinel.redis.zrem(index(p), prev_id)
          end
        end
      end
    end

  end
end
