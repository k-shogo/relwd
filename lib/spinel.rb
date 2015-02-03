require 'redis'
require 'multi_json'
require "spinel/version"
require "spinel/config"
require "spinel/helper"
require "spinel/backend"
require "spinel/matcher"
require "spinel/client"

module Spinel
  extend Config

  def self.new type = :default
    Client.new type
  end

end
