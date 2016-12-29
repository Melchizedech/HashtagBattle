class UserController < ApplicationController
  include ApplicationHelper
  before_action :require_login

  def show
    @user          = current_user
    @access_token = Doorkeeper::AccessToken.where(:application_id => Doorkeeper::Application.first.id, :resource_owner_id => current_user.id, :revoked_at => nil).first

  end

  def generate_access_token
    access_token = Doorkeeper::AccessToken.create!(:application_id => Doorkeeper::Application.first.id, :resource_owner_id => current_user.id)
    redirect_to show_user_path
  end  

end
