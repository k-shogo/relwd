module Spinel
  module Helper

    def prefixes_for_phrase(phrase)
      squish(phrase).split.flat_map do |w|
        (Spinel.min_complete-1..(w.length-1)).map{ |l| w[0..l] }
      end.uniq
    end

    def squish str
      str.to_s.gsub(/[[:space:]]+/, ' ').strip
    end

    def document_validate doc
      raise ArgumentError, "documents must specify both an id and a body" unless document_id(doc) && document_body(doc)
    end

    def document_id doc
      doc[:id] || doc["id"]
    end

    def document_score doc
      doc[:score] || doc["score"]
    end

    def document_body doc
      doc[Spinel.document_key.to_sym] || doc[Spinel.document_key]
    end

  end
end
