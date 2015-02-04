require 'dotenv'
require "codeclimate-test-reporter"
require 'simplecov'

Dotenv.load
CodeClimate::TestReporter.start if ENV['CCR']

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
  config.minimal_word = 2
  config.cache_expire = 600
  config.search_limit = 10
  config.document_key = :body
  config.namespace    = 'spinel'
end

def test_data
  [
    {id: 1, body: 'and all with pearl and ruby glowing'},
    {id: 2, body: 'yellow or orange variety of ruby spinel'},
    {id: 3, body: 'colour called pearl yellow'},
    {id: 4, body: 'mandarin orange net sack'},
    {id: 5, body: 'spinel used as a gemstone usually dark red'},
    {id: 6, body: 'today is hotter than usual'},
    {id: 7, body: 'call on a person'},
    {id: 8, body: 'that gem is shining'},
    {id: 9, body: 'polish shoes to a bright shine'}
  ]
end
