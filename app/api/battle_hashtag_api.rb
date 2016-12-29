class BattleHashtagAPI < Grape::API
  format :json
  use ::WineBouncer::OAuth2
  mount V1::Base
end