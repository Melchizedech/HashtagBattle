module Entities
  class DetailedBattleEntity < BattleEntity
    expose :hashtags, using: Entities::DetailedHashtagEntity, documentation: { type: Entities::DetailedHashtagEntity, desc: 'Hashtags involved in the Battle'}
  end
end
