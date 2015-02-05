require 'test_helper'

class SearcherTest < SpinelTestBase

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
