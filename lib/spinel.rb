require 'redis'
require 'multi_json'
require "spinel/version"
require "spinel/config"
require "spinel/helper"
require "spinel/base"
require "spinel/backend"
require "spinel/matcher"

module Spinel
  extend Config

  def self.backend type = :default
    Backend.new type
  end

  def self.matcher type = :default
    Matcher.new type
  end
end
