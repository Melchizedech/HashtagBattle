module Entities
  class HashtagWithGlobalCountEntity < HashtagEntity
    expose :total_count, documentation: { type: Integer, desc: 'Global count of the Hashtag since created'}do |h, options|
      h.get_total_count
    end
  end
end