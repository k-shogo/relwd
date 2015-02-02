module Spinel
  class Base
    include Helper

    attr_accessor :type

    def initialize type = :default
      @type = type
    end

    def namespace
      'spinel'
    end

    def base
      "#{namespace}:index:#{type}"
    end

    def base_and p
      "#{base}:#{p}"
    end

    def database
      "#{namespace}:data:#{type}"
    end

    def cachebase
      "#{namespace}:cache:#{type}"
    end

    def cachekey words
      "#{cachebase}:#{words.join('|')}"
    end
  end
end
