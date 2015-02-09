require 'redis'
require 'multi_json'
require "spinel/version"
require "spinel/config"
require "spinel/helper"
require "spinel/indexer"
require "spinel/searcher"
require "spinel/connection_pool_proxy"
require "spinel/client"

module Spinel
  extend Config

  def self.new type = :default
    Client.new type
  end

  def self.method_missing(method_name, *args, type: :default, &block)
    return super unless new(type).respond_to?(method_name)
    new(type).send(method_name, *args, &block)
  end

  def self.respond_to?(method_name, include_private = false)
    new.respond_to?(method_name, include_private) || super
  end

end
