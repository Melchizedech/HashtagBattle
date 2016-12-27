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
end
