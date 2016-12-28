Doorkeeper.configure do
  resource_owner_authenticator do
    User.find_by_id(session[:user_id]) || redirect_to('/auth/twitter')
  end
end
