class HomeController < ApplicationController

  def index
    @user ||= (session[:user_id] && User.find(session[:user_id]))
    @battles = @user.nil? ? [] : @user.battles 
  end

  def login
    session[:token] = TwitterSignIn.request_token
    redirect_to TwitterSignIn.authenticate_url(session[:token])
  end

  def load
    session[:user_id] = 4
    @user = User.find(4)
    render 'verify'
  end

  def verify
    @token = session[:token]
  end

  def callback
    token = TwitterSignIn.access_token(params["oauth_token"], params["oauth_verifier"])
    if token
      user_twitter = TwitterSignIn.verify_credentials(token)
      @user = User.find_or_initialize_by(sid: user_twitter['id_str'])
      @user.access_token ||= token
      @user.mail ||= user_twitter['screen_name']
      @user.save!
      session[:user_id] = @user.id
      session[:token] = nil
    else 
      flash[:error] = "Did not get authorization to access Twitter account"
    end
    redirect_to action: :index
  end  

  def logout
    reset_session
    redirect_to action: :index
  end

end
