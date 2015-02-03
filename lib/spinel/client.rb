module Spinel
  class Client
    include Helper
    include Indexer
    include Searcher

    attr_accessor :type

    def initialize type = :default
      @type = type
    end

    def index p
      "#{Spinel.namespace}:index:#{type}:#{p}"
    end

    def database
      "#{Spinel.namespace}:data:#{type}"
    end

    def cachekey words
      "#{Spinel.namespace}:cache:#{type}:#{words.join('|')}"
    end
  end
end
