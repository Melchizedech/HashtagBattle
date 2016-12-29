module V1
  class Base < BattleHashtagAPI
    version "v1", :using => :path
    include Grape::Kaminari
    
    mount HashtagAPI
    mount MeAPI
    mount BattleAPI
    add_swagger_documentation \
      base_path: '/api',
      api_version: 'v1',
      hide_format: true, # don't show .json
      hide_documentation_path: true,
      mount_path: '/swagger_doc',
      endpoint_auth_wrapper: WineBouncer::OAuth2,
      info: {
        title: 'HashtagBattle API'
      }
  end
end