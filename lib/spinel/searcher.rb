module Spinel
  module Searcher

    def search term, options = {}
      options = { limit: Spinel.minimal_word, cache: true }.merge(options)

      words = squish(term).split.reject{|w| w.size < Spinel.minimal_word}.sort
      return [] if words.empty?

      tmp_cachekey = cachekey(words)

      unless options[:cache] && Spinel.redis.exists(tmp_cachekey)
        interkeys = words.map{ |w| index w }
        Spinel.redis.zinterstore(tmp_cachekey, interkeys)
        Spinel.redis.expire(tmp_cachekey, Spinel.cache_expire)
      end

      ids = Spinel.redis.zrevrange(tmp_cachekey, 0, options[:limit] - 1)
      ids.empty? ? [] : Spinel.redis.hmget(database, *ids).compact.map{|json| MultiJson.decode(json)}

    end

  end
end
