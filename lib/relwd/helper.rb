module Relwd
  module Helper

    def prefixes_for_phrase(phrase)
      words = phrase.split(' ')
      words.map do |w|
        (Relwd.min_complete-1..(w.length-1)).map{ |l| w[0..l] }
      end.flatten.uniq
    end

    def item_to_phrase item
      [item_term(item), *Array(item_aliases(item))].join(' ')
    end

    def item_validate item
      raise ArgumentError, "Items must specify both an id and a term" unless item_id(item) && item_term(item)
    end

    def item_id item
      item[:id] || item["id"]
    end

    def item_score item
      item[:score] || item["score"]
    end

    def item_term item
      item[:term] || item["term"]
    end

    def item_aliases item
      item[:aliases] || item["aliases"]
    end

  end
end
