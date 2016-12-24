module ApplicationHelper
  def require_login
    redirect_to ('/' + twitter_auth_path) unless session[:user_id]
  end

  def twitter_auth_path
    'auth/twitter'
  end

  def current_user
    @user ||= session[:user_id] ? User.find(session[:user_id]) : nil
  end
end
