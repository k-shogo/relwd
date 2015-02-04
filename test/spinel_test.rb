require 'test_helper'

class SpinelTest < Minitest::Test
  def setup
    @spinel = Spinel.new
  end

  def test_redis
    assert { 'PONG' == Spinel.redis.ping }

    Spinel.redis = 'redis://127.0.0.1:6379/0'
    assert { 'PONG' == Spinel.redis.ping }

    mock_redis = MockRedis.new
    Spinel.redis = mock_redis
    assert { mock_redis.object_id == Spinel.redis.object_id }
  end

  def test_respond_to?
   assert Spinel.respond_to? :store
   assert Spinel.respond_to? :remove
   assert Spinel.respond_to? :get
   assert Spinel.respond_to? :search
  end

  def test_method_missing
    Spinel.redis.flushall
    Spinel.store({id: 1, body: 'test'},{})
    assert { 1 == Spinel.redis.hlen(@spinel.database) }
  end

  def test_database_index
    assert { 'spinel:data:default' == @spinel.database }
  end

  def test_index
    assert { 'spinel:index:default:term' == @spinel.index(:term) }
  end

  def test_cachekey_index
    assert { 'spinel:cache:default:word1|word2' == @spinel.cachekey(%w(word1 word2)) }
  end

  def test_prefixes
    assert { ["ta", "tak", "take", "tal", "talk"] == @spinel.prefixes("take talk") }
  end

  def test_squish
    assert { "quick brown fox" == @spinel.squish("  quick \t  brown\n fox  ") }
  end

  def test_get_valid_document
    assert_raises(ArgumentError){ @spinel.get_valid_document({id: 1}) }
    assert_raises(ArgumentError){ @spinel.get_valid_document({body: 'body'}) }
    assert { [1, 'body', 0.0] == @spinel.get_valid_document({id: 1, body: 'body'}) }
  end

  def test_document_id
    assert { "doc_id" == @spinel.document_id({id: "doc_id"}) }
    assert { "doc_id" == @spinel.document_id({"id" => "doc_id"}) }
  end

  def test_document_score
    assert { 1.0 == @spinel.document_score({score: 1}) }
    assert { 1.0 == @spinel.document_score({"score" => 1}) }
    assert { 0.0 == @spinel.document_score({}) }
  end

  def test_document_body
    assert { "doc_body" == @spinel.document_body({body: "doc_body"}) }
    assert { "doc_body" == @spinel.document_body({"body" => "doc_body"}) }
  end

  def test_minimal_word
    assert { 2 == Spinel.minimal_word }
  end

  def test_cache_expire
    assert { 600 == Spinel.cache_expire }
  end

  def test_search_limit
    assert { 10 == Spinel.search_limit }
  end

  def test_document_key
    assert { 'body' == Spinel.document_key }
  end

  def test_namespace
    assert { 'spinel' == Spinel.namespace }
  end

  def test_store
    Spinel.redis.flushall
    @spinel.store id: 1, body: 'test'
    assert { 1 == Spinel.redis.hlen(@spinel.database) }
  end

  def test_get
    Spinel.redis.flushall
    @spinel.store id: 1, body: 'test'
    assert { {"id" => 1, "body" => 'test'} == @spinel.get(1) }
  end

  def test_remove
    Spinel.redis.flushall
    @spinel.store id: 1, body: 'test'
    @spinel.remove id: 1
    assert { 0 == Spinel.redis.hlen(@spinel.database) }
  end

  def test_search
    Spinel.redis.flushall
    @spinel.store id: 1, body: 'ruby'
    @spinel.store id: 2, body: 'rubx'
    assert { 2 == @spinel.search('rub').size }
    assert { 1 == @spinel.search('ruby').size }
  end

  def test_search_option
    assert { {limit: 10, cache: true} == @spinel.search_option }
    assert { {limit: 1, cache: true} == @spinel.search_option({limit: 1}) }
    assert { {limit: 10, cache: false} == @spinel.search_option({cache: false}) }
  end

  def test_search_word_split
    assert { ['test','word'] == @spinel.search_word_split('test word') }
    assert { ['abc','def'] == @spinel.search_word_split('  def   abc  ') }
  end
end
