module Spinel
  module Config
    DEFAULT_MINIMAL_WORD = 2
    DEFAULT_CACHE_EXPIRE = 600
    DEFAULT_SEARCH_LIMIT = 10
    DEFAULT_DOCUMENT_KEY = :body
    DEFAULT_NAMESPACE    = 'spinel'

    attr_writer :minimal_word, :cache_expire, :search_limit, :document_key, :namespace

    def minimal_word
      @minimal_word ||= DEFAULT_MINIMAL_WORD
    end

    def cache_expire
      @cache_expire ||= DEFAULT_CACHE_EXPIRE
    end

    def search_limit
      @search_limit ||= DEFAULT_SEARCH_LIMIT
    end

    def document_key
      (@document_key ||= DEFAULT_DOCUMENT_KEY).to_s
    end

    def namespace
      @namespace ||= DEFAULT_NAMESPACE
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
