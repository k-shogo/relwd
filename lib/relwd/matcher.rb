module Relwd
  class Matcher < Base

    def matches_for_term(term, options = {})
      options = { limit: Relwd.match_limit, cache: true }.merge(options)

      words = term.split(' ').reject do |w|
        w.size < Relwd.min_complete
      end.sort

      return [] if words.empty?

      tmp_cachekey = cachekey(words)

      if !options[:cache] || !Relwd.redis.exists(tmp_cachekey) || Relwd.redis.exists(tmp_cachekey) == 0
        interkeys = words.map { |w| base_and w }
        Relwd.redis.zinterstore(tmp_cachekey, interkeys)
        Relwd.redis.expire(tmp_cachekey, Relwd.cache_expire)
      end

      ids = Relwd.redis.zrevrange(tmp_cachekey, 0, options[:limit] - 1)
      if ids.size > 0
        results = Relwd.redis.hmget(database, *ids)
        results = results.reject{ |r| r.nil? }
        results.map { |r| MultiJson.decode(r) }
      else
        []
      end
    end

  end
end
