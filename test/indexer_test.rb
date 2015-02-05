require 'test_helper'

class IndexerTest < SpinelTestBase

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
end
