module Spinel
  class Base
    include Helper

    attr_accessor :type

    def initialize type = :default
      @type = type
    end

    def base
      "#{Spinel.namespace}:index:#{type}"
    end

    def base_and p
      "#{base}:#{p}"
    end

    def database
      "#{Spinel.namespace}:data:#{type}"
    end

    def cachebase
      "#{Spinel.namespace}:cache:#{type}"
    end

    def cachekey words
      "#{cachebase}:#{words.join('|')}"
    end
  end
end
