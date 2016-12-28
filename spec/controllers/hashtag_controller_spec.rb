require "rails_helper"

RSpec.describe HashtagController, :type => :controller do

  describe 'Hashtag page' do

    it 'displays all hashtags (unlogged)' do
      get :index
      5.times do create(:hashtag) end
      expect(response.status).to eq(200)
      expect(session[:user_id]).to be_nil   
      expect(assigns(:user)).to be(nil)
      expect(assigns(:hashtags).size).to be(5)
    end

    it 'displays current user' do
      login
      get :index
      expect(session[:user_id]).not_to be_nil   
      expect(assigns(:user)).not_to be(nil)      
    end
  end

  describe 'user_hashtags' do
    it 'redirect to log in' do
      get :user_hashtags
      expect(response.status).to be(302)
    end

    it 'displays users hashtags' do
      user = login      
      battle = build(:battle, user: user)
      2.times do battle.hashtags << create(:hashtag) end
      battle.save
      get :user_hashtags
      expect(assigns(:hashtags).size).to be(2)
    end
  end

  describe 'show' do
    it 'displays a hashtag' do
      h = create(:hashtag)
      get :show, id: h.id
      expect(assigns(:hashtag)).to eq(h)
    end

    it 'fails to display hashtag' do
      expect { get :show, id: 'random_id'}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'displays a user' do
      h = create(:hashtag)
      user = login
      get :show, id: h.id
      expect(assigns(:user)).not_to be(nil)
    end
  end

  describe 'update count' do
    it 'fails to update unlogged' do
      h = create(:hashtag)
      get :update_count, id: h.id
      expect(response.status).to be(302)
    end

    it 'fails to update unknown hashtag' do
      login
      expect { get :update_count, id: 'random_id'}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'updates count' do
      login
      VCR.use_cassette('twitter_interface/query_hashtag') do
        hashtag = create(:hashtag, name: '#qwerty')
        request = YAML.load(File.read('spec/vcr/twitter_interface/query_hashtag.yml'))
        date    = request['http_interactions'][0]['request']['uri'].match(/.*since=([^&]*)/)[1].to_date
        Delorean.time_travel_to date do
          get :update_count, id: hashtag.id
          expect(response.status).to be(204)
          expect(hashtag.get_total_count).to be(2)
          expect(hashtag.get_last_tweet_id).not_to be_nil
        end
      end
    end
  end

  describe 'evolution chart' do
    it 'fails to generate for unknown id' do
      expect { get :evolution_chart_data, hashtag_id: 'random_id'}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'generates empty evolution chart' do
      h = create(:hashtag)
      get :evolution_chart_data, hashtag_id: h.id
      expect(response.body).to eq([{name: h.name, data:[]}].to_json)      
    end
  end
end
