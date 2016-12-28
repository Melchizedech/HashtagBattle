module Entities
  class BattleEntity < Grape::Entity
    expose :id, documentation: { type: Integer, desc: 'ID of the Battle'}
    expose :hashtags, using: Entities::HashtagEntity, documentation: { type: Entities::HashtagEntity, desc: 'Hashtags involved in the Battle'}
  end
end
