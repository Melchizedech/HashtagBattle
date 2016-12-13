class HomeController < ApplicationController

  def index
    Rails.logger.info("SESSION : #{session[:user]}")
    @user ||= session[:user]
    @battles = @user.nil? ? [] : User.battles 
  end
end
