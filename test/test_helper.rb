require 'simplecov'
SimpleCov.start do
  add_filter "vendor"
end

require 'spinel'
require 'mock_redis'
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest-power_assert'

Spinel.configure do |config|
  config.redis        = MockRedis.new
  config.min_complete = 2
  config.cache_expire = 600
  config.match_limit  = 10
  config.document_key = :body
  config.namespace    = 'spinel'
end
