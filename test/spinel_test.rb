require 'test_helper'

class SpinelTest < SpinelTestBase

  def test_redis
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

end
