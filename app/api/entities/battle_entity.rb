module Entities
  class BattleEntity < Grape::Entity
    expose :id, documentation: { type: Integer, desc: 'ID of the Battle'}
    expose :hashtags, using: Entities::HashtagEntity, documentation: { type: Entities::HashtagEntity, desc: 'Hashtags involved in the Battle'}
    expose :created_at, as: :battle_since, documentation: { type: Date, desc: 'Battle ongoing since'} do |b, options|
      b.created_at.to_date
    end
  end
end
