module V1
  class MeAPI < Base

    desc 'End-points for User related stuff'
    namespace :me do
      desc 'Get your Battles', {
        success: Entities::SummarizedBattleEntity,
        failure: [[401, 'Not logged in']]        
      }
      oauth2
      get :battles do
        present paginate(resource_owner.battles), with: Entities::SummarizedBattleEntity
      end


      desc 'Get your Hashtags', {
        success: Entities::HashtagEntity,
        failure: [[401, 'Not logged in']]        
      }   
      oauth2   
      get :hashtags do
        hashtags = Hashtag.joins(:battles).where("battles.user_id = ?", resource_owner.id).includes(:battles).distinct
        present paginate(hashtags), with: Entities::HashtagEntity
      end
    end
  end
end