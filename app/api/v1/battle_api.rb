module V1
  class BattleAPI < Base

    desc 'End-points for Battle related stuff'
    namespace :battles do
      desc 'Get all battles', {
        success: Entities::SummarizedBattleEntity,
        failure: [[404, 'Battle not Found']]        
      }
      get do
        present paginate(Battle.all), with: Entities::SummarizedBattleEntity
      end

      route_param :id do
        desc 'Get specific battle', {
          success: Entities::BattleEntity,
          failure: [[404, 'Battle not Found']]        
        }
        get do
          present Battle.find(params[:id]), with: Entities::BattleEntity
        end

        desc 'Get summarized data for battle', {
          failure: [[404, 'Battle not Found']]        
        }
        get :summarized do
          battle = Battle.find(params[:id])
          present battle.hashtags.map { |h| [h.name, h.get_count_between(before: battle.created_at)] }
        end

        desc 'Get evolution data for battle', {
          failure: [[404, 'Battle not Found']]        
        }
        get :evolution do
          battle = Battle.find(params[:id])
          data   = []

          battle.hashtags.each do |h|
            data << h.get_stacked_evolution_data(from: battle.created_at)
          end
          present data
        end
      end
    end
  end
end