require 'test_helper'

class SpinelTest < Minitest::Test
  def setup
    @spinel = Spinel.new
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

end
