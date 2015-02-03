module Spinel
  module Matcher

    def matches(term, options = {})
      options = { limit: Spinel.match_limit, cache: true }.merge(options)

      words = squish(term).split.reject{|w| w.size < Spinel.min_complete}.sort
      return [] if words.empty?

      tmp_cachekey = cachekey(words)

      unless options[:cache] && Spinel.redis.exists(tmp_cachekey)
        interkeys = words.map{ |w| base_and w }
        Spinel.redis.zinterstore(tmp_cachekey, interkeys)
        Spinel.redis.expire(tmp_cachekey, Spinel.cache_expire)
      end

      ids = Spinel.redis.zrevrange(tmp_cachekey, 0, options[:limit] - 1)
      ids.empty? ? [] : Spinel.redis.hmget(database, *ids).compact.map{|json| MultiJson.decode(json)}

    end

  end
end
