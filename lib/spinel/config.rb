module Spinel
  module Config
    DEFAULT_MIN_COMPLETE = 2
    DEFAULT_CACHE_EXPIRE = 600
    DEFAULT_MATCH_LIMIT  = 10
    DEFAULT_DOCUMENT_KEY = :body

    attr_writer :min_complete, :cache_expire, :match_limit, :document_key

    def min_complete
      @min_complete ||= DEFAULT_MIN_COMPLETE
    end

    def cache_expire
      @cache_expire ||= DEFAULT_CACHE_EXPIRE
    end

    def match_limit
      @match_limit ||= DEFAULT_MATCH_LIMIT
    end

    def document_key
      (@document_key ||= DEFAULT_DOCUMENT_KEY).to_s
    end

    def redis=(server)
      if server.is_a?(String)
        @redis = nil
        @redis_url = server
      else
        @redis = server
      end

      redis
    end

    def redis
      @redis ||= (
        url = URI(@redis_url || ENV["REDIS_URL"] || "redis://127.0.0.1:6379/0")

        ::Redis.new({
          host:     url.host,
          port:     url.port,
          db:       url.path[1..-1],
          password: url.password
        })
      )
    end

    def configure
      yield self
      self
    end

  end
end
