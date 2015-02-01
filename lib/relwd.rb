require 'redis'
require 'multi_json'
require "relwd/version"
require "relwd/config"
require "relwd/helper"
require "relwd/base"
require "relwd/backend"
require "relwd/matcher"

module Relwd
  extend Config

  def self.backend type = :default
    Backend.new type
  end

  def self.matcher type = :default
    Matcher.new type
  end
end
