module Relwd
  module Helper

    def prefixes_for_phrase(phrase)
      words = phrase.split(' ')
      words.map do |w|
        (Relwd.min_complete-1..(w.length-1)).map{ |l| w[0..l] }
      end.flatten.uniq
    end

    def item_to_phrase item
      ([item["term"]] + (item["aliases"] || [])).join(' ')
    end

    def item_validate item
      raise ArgumentError, "Items must specify both an id and a term" unless item["id"] && item["term"]
    end

    def item_id
      item["id"]
    end

    def item_score
      item["score"]
    end

  end
end
