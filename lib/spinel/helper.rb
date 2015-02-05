module Spinel
  module Helper

    def prefixes str
      squish(str).split.flat_map do |w|
        (Spinel.minimal_word-1..(w.length-1)).map{ |l| w[0..l] }
      end.uniq
    end

    def squish str
      str.to_s.gsub(/[[:space:]]+/, ' ').strip
    end

    def get_valid_document doc
      id = document_id doc
      raise ArgumentError, "documents must specify id" unless id
      [id, document_index_fields(doc), document_score(doc)]
    end

    def document_id doc
      doc[:id] || doc["id"]
    end

    def document_score doc
      (doc[:score] || doc["score"]).to_f
    end

    def document_index_fields doc
      Spinel.index_fields.map {|field|
        doc[field.to_s.to_sym] || doc[field.to_s] || doc[field]
      }.compact.join(' ')
    end

  end
end
