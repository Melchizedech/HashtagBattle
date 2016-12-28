class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @user          = current_user
    set            = @user ? @user.battles : Battle.all
    @random_battle = set.order("RANDOM()").limit(1).first
  end

  # Callback of Twitter authentication
  def callback
    access_token               = request.env['omniauth.auth'][:credentials][:token]
    secret_token               = request.env['omniauth.auth'][:credentials][:secret]
    twitter_uuid               = request.env['omniauth.auth'][:uid]
    @user                      = User.find_or_initialize_by(sid: twitter_uuid)
    @user.name               ||= request.env['omniauth.auth'][:info][:name]
    @user.access_token         = access_token
    @user.secret_access_token  = secret_token
    @user.save!
    session[:user_id]          = @user.id
    redirect_to action: :index
  end  

  def failure
    flash[:error] = 'Couldn\'t get authorized to access Twitter account'
    redirect_to action: :index
  end  

  def logout
    reset_session
    redirect_to action: :index
  end

end
