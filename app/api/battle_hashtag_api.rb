class BattleHashtagAPI < Grape::API
  format :json

  mount V1::Base
end