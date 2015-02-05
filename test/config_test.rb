require 'test_helper'

class ConfigTest < SpinelTestBase

  def test_minimal_word
    assert { 2 == Spinel.minimal_word }
  end

  def test_cache_expire
    assert { 600 == Spinel.cache_expire }
  end

  def test_search_limit
    assert { 10 == Spinel.search_limit }
  end

  def test_index_fields
    assert { [:body] == Spinel.index_fields }
  end

  def test_namespace
    assert { 'spinel' == Spinel.namespace }
  end
end
