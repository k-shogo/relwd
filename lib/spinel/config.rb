module Spinel
  module Config
    DEFAULT_MINIMAL_WORD = 2
    DEFAULT_CACHE_EXPIRE = 600
    DEFAULT_SEARCH_LIMIT = 10
    DEFAULT_INDEX_FIELDS = [:body]
    DEFAULT_NAMESPACE    = 'spinel'

    attr_writer :minimal_word, :cache_expire, :search_limit, :index_fields, :namespace

    def minimal_word
      @minimal_word ||= DEFAULT_MINIMAL_WORD
    end

    def cache_expire
      @cache_expire ||= DEFAULT_CACHE_EXPIRE
    end

    def search_limit
      @search_limit ||= DEFAULT_SEARCH_LIMIT
    end

    def index_fields
      Array(@index_fields ||= DEFAULT_INDEX_FIELDS)
    end

    def namespace
      @namespace ||= DEFAULT_NAMESPACE
    end

    def redis= conn
      @redis = Spinel::ConnectionPoolProxy.proxy_if_needed(conn)
    end

    def redis
      @redis || $redis || Redis.current ||
        raise(NotConnected, "Redis::Objects.redis not set to a Redis.new connection")
    end

    def configure
      yield self
      self
    end

  end
end
