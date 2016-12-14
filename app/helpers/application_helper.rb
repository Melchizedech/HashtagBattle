module ApplicationHelper
  def require_login
    redirect_to controller: :home, action: :login unless session[:user_id]
  end

  def current_user
    @user ||= session[:user_id] ? User.find(session[:user_id]) : nil
  end
end
