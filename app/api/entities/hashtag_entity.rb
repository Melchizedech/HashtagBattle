module Entities
  class HashtagEntity < Grape::Entity
    expose :id, documentation: { type: Integer, desc: 'ID of the Hashtag' }
    expose :name, documentation: { type: String, desc: 'Name of the Hashtag' }
    expose :daily_hashtag_counts, as: :counts, using: Entities::DailyHashtagCountEntity, documentation: { type: Entities::DailyHashtagCountEntity, desc: 'Counts of the Hashtag' }
  end
end
