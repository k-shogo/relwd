require 'test_helper'

class HelperTest < SpinelTestBase

  def test_prefixes
    assert { ["ta", "tak", "take", "tal", "talk"] == @spinel.prefixes("take talk") }
  end

  def test_squish
    assert { "quick brown fox" == @spinel.squish("  quick \t  brown\n fox  ") }
  end

  def test_get_valid_document
    assert_raises(ArgumentError){ @spinel.get_valid_document({body: 'body'}) }
    assert { [1, 'body', 0.0] == @spinel.get_valid_document({id: 1, body: 'body'}) }
    assert { [1, '', 0.0] == @spinel.get_valid_document({id: 1}) }
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

  def test_document_index_fields
    assert { "test" == @spinel.document_index_fields({body: "test"}) }
    assert { "test" == @spinel.document_index_fields({"body" => "test"}) }
    Spinel.index_fields = [:index, :aliase]
    assert { "test word" == @spinel.document_index_fields({index: "test", "aliase" => "word"}) }
    assert { "test word" == @spinel.document_index_fields({"index" => "test", aliase: "word"}) }
    Spinel.index_fields = Spinel::Config::DEFAULT_INDEX_FIELDS
  end
end
