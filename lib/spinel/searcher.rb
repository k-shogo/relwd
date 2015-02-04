module Spinel
  module Searcher

    def search term, options = {}
      options = search_option options
      words = search_word_split term
      return [] if words.empty?

      tmp_cachekey = cachekey(words)

      set_cache(tmp_cachekey, words) unless options[:cache] && cache_enable(tmp_cachekey)

      ids = Spinel.redis.zrevrange(tmp_cachekey, 0, options[:limit] - 1)
      ids.empty? ? [] : Spinel.redis.hmget(database, *ids).compact.map{|json| MultiJson.decode(json)}
    end

    def search_option options = {}
      { limit: Spinel.minimal_word, cache: true }.merge(options)
    end

    def search_word_split word
      squish(word).split.reject{|w| w.size < Spinel.minimal_word}.sort
    end

    def set_cache key, words
      interkeys = words.map{ |w| index w }
      Spinel.redis.zinterstore(key, interkeys)
      Spinel.redis.expire(key, Spinel.cache_expire)
    end

    def cache_enable key
      Spinel.redis.exists(key)
    end

  end
end
