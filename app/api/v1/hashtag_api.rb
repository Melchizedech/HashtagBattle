module V1
  class HashtagAPI < Base
    desc 'End-points for Hashtag related stuff'
    namespace :hashtag do

      desc 'Get all Hashtags', {
        success: Entities::HashtagEntity,
        failure: [[404, 'Hashtag not Found']]        
      }      
      get do
        present Hashtag.all, with: Entities::HashtagEntity
      end

      route_param :id do
        desc 'Get specific Hashtag', {
          success: Entities::HashtagWithGlobalCountEntity,
          failure: [[404, 'Hashtag not Found']]        
        }
        get do
          present Hashtag.find(params[:id]), with: Entities::HashtagWithGlobalCountEntity
        end

        desc 'Get evolution data of Hashtag', {
          failure: [[404, 'Hashtag not Found']]        
        }
        get :evolution do
          hashtag = Hashtag.find(params[:id])
          result  = [hashtag.get_stacked_evolution_data(from: hashtag.created_at)]
          present result
        end
      end
    end
  end
end