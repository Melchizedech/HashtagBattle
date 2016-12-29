module V1
  class HashtagAPI < Base
    desc 'End-points for Hashtag related stuff'
    namespace :hashtags do

      desc 'Get all Hashtags', {
        success: Entities::HashtagEntity
      }      
      get do
        present paginate(Hashtag.all), with: Entities::HashtagEntity
      end

      route_param :id do
        desc 'Get specific Hashtag', {
          success: Entities::DetailedHashtagEntity,
          failure: [[404, 'Hashtag not Found']]        
        }
        get do
          present Hashtag.find(params[:id]), with: Entities::DetailedHashtagEntity
        end

        desc 'Get evolution data of Hashtag', {
          failure: [[404, 'Hashtag not Found']]        
        }
        get :evolution do
          hashtag = Hashtag.find(params[:id])
          result  = [hashtag.get_stacked_evolution_data(from: hashtag.created_at)]
          present result
        end

        desc 'Update Hashtag count', {
          failure: [[404, 'Hashtag not Found'], [401, 'Not logged in']]
        }
        oauth2
        patch do
          at            = Time.now
          twitter       = TwitterInterface.new(resource_owner)
          count         = twitter.fetch_tweet_count(hashtag, at)
          last_tweet_id = twitter.last_tweet_id
          hashtag.update_count(add: count, last_tweet_id: last_tweet_id)
        end
      end
    end
  end
end