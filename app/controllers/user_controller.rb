class UserController < ApplicationController

  def login
    session[:token] = TwitterSignIn.request_token
    redirect_to TwitterSignIn.authenticate_url(session[:token])
  end

  def verify
    @token = session[:token]
  end

  def callback
    token = TwitterSignIn.access_token(params["oauth_token"], params["oauth_verifier"])
    if token
      user_twitter = TwitterSignIn.verify_credentials(token)
      user = User.find_or_initialize_by(sid: user_twitter['id_str'])
      user.access_token ||= token
      user.mail ||= user_twitter['screen_name']
      user.save!
      session[:user] = user
      Rails.logger.info("SESSION : #{session[:user]}")
      session[:token] = nil
    else 
      flash[:error] = "Did not get authorization to access Twitter account"
    end
    redirect_to 'home#index'
  end  

  def logout
    reset_session
    redirect_to 'home#index'
  end

  def load
    session[:user] = User.find(4)
    Rails.logger.info("SESSION : #{session[:user]}")
    redirect_to 'home#index'
  end

  def index
  end 
end
