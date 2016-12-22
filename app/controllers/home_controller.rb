class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @user          = current_user
    set            = @user ? @user.battles : Battle.all
    @random_battle = set.order("RANDOM()").limit(1).first
  end

  def login
    request_token, secret_request_token = TwitterInterface.request_token
    session[:secret_request_token]      = secret_request_token
    @request_url                        = TwitterInterface.authenticate_url(request_token)
    @request_token                      = request_token
  end

  def callback
    access_token, secret_token = TwitterInterface.access_token(params["oauth_token"], session[:secret_request_token], params["oauth_verifier"])
    user_twitter               = TwitterInterface.verify_credentials(access_token, secret_token) if access_token

    if user_twitter
      @user                     = User.find_or_initialize_by(sid: user_twitter['id_str'])
      @user.mail              ||= user_twitter['screen_name']
      @user.access_token        = access_token
      @user.secret_access_token = secret_token
      @user.save!
      session[:user_id]         = @user.id
    else 
      flash[:error] = "Did not get authorization to access Twitter account"
    end
    
    session[:secret_request_token] = nil
    redirect_to action: :index
  end  

  def logout
    reset_session
    redirect_to action: :index
  end

end
