require 'test_helper'

class ConnectionPoolProxy < Minitest::Test

  def setup
    @proxy = Spinel::ConnectionPoolProxy.new(ConnectionPool.new { MockRedis.new  })
  end

  def test_initialize
    assert_raises(ArgumentError){ Spinel::ConnectionPoolProxy.new 'string'  }
  end

  def test_method_missing
    assert { 'PONG' == @proxy.ping }
  end

  def test_respond_to?
    assert { true == @proxy.respond_to?(:ping) }
  end

  def test_should_proxy?
    assert { true == Spinel::ConnectionPoolProxy.should_proxy?(ConnectionPool.new { MockRedis.new })  }
  end

end
