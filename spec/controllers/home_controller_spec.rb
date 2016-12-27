require "rails_helper"

RSpec.describe HomeController, :type => :controller do

  describe 'Index page' do

    it 'displays index page (logged out)' do
      get :index
      expect(response.status).to eq(200)
      expect(session[:user_id]).to be_nil   
      expect(assigns(:user)).to be(nil)
      expect(assigns(:random_battle)).to be(nil)
    end

    it 'displays current user' do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
      post :callback, provider: :twitter
      get :index
      expect(assigns(:user)).not_to be(nil)
      expect(assigns(:random_battle)).to be(nil)     
    end
  end

  describe 'Callback login' do

    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end
 
    it 'Adds a new user in DB' do
      expect {
        post :callback, provider: :twitter
      }.to change{ User.count }.by(1)
    end

    it 'Should redirect after login to index' do
      post :callback, provider: :twitter
      expect(response).to redirect_to :root
    end

    it 'Should create a session' do
      post :callback, provider: :twitter
      expect(session[:user_id]).not_to be_nil   
      expect(assigns(:user)).not_to be_nil
      expect(assigns[:user].sid).to eq('123545')
    end
  end

  describe 'Failure login' do

    it 'Should fail to create a session' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials 
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]  
      post :failure, provider: :twitter
      expect(session[:user_id]).to be_nil   
      expect(assigns(:user)).to be_nil
    end    

    it 'Should redirect to index' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials 
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]  
      post :failure, provider: :twitter
      expect(response).to redirect_to :root
    end
  end
end
