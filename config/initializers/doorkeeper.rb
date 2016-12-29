Doorkeeper.configure do
  resource_owner_authenticator do
    User.find_by_id(session[:user_id]) || redirect_to('/auth/twitter')
  end
  admin_authenticator do |routes|
    redirect_to(root_path)
  end
end
