module Entities
  class SummarizedBattleEntity < BattleEntity
    expose :hashtags, using: Entities::HashtagWithGlobalCountEntity, documentation: { type: Entities::HashtagWithGlobalCountEntity, desc: 'Hashtags involved in the Battle'}
  end
end
