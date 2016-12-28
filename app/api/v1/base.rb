module V1
  class Base < BattleHashtagAPI
    version "v1", :using => :path
    include Grape::Kaminari
    
    mount HashtagAPI
    mount BattleAPI
    add_swagger_documentation info: { title: 'BattleHashtag API' }

  end
end