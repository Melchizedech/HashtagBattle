module SpecTestHelper   
  def login
    user = create(:user)
    request.session[:user_id] = user.id
    user
  end
end

