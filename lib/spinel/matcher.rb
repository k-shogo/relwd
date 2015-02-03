module Spinel
  module Matcher

    def matches(term, options = {})
      options = { limit: Spinel.match_limit, cache: true }.merge(options)

      words = squish(term).split.reject{|w| w.size < Spinel.min_complete}.sort

      return [] if words.empty?

      tmp_cachekey = cachekey(words)

      if !options[:cache] || !Spinel.redis.exists(tmp_cachekey) || Spinel.redis.exists(tmp_cachekey) == 0
        interkeys = words.map { |w| base_and w }
        Spinel.redis.zinterstore(tmp_cachekey, interkeys)
        Spinel.redis.expire(tmp_cachekey, Spinel.cache_expire)
      end

      ids = Spinel.redis.zrevrange(tmp_cachekey, 0, options[:limit] - 1)
      if ids.size > 0
        results = Spinel.redis.hmget(database, *ids)
        results = results.reject{ |r| r.nil? }
        results.map { |r| MultiJson.decode(r) }
      else
        []
      end
    end

  end
end
