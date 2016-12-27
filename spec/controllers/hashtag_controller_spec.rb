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
      login_with_omniauth
      get :index
      expect(session[:user_id]).not_to be_nil   
      expect(assigns(:user)).not_to be(nil)      
    end
  end
end
