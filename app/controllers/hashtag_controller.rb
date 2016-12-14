class HashtagController < ApplicationController
  include ApplicationHelper

  before_action :require_login

  def index
    @hashtags = Hashtag.joins(:battles).where("battles.user_id = ?", current_user.id).includes(:battles).distinct
  end

  def show
    @hashtag = Hashtag.joins(:battles).where("battles.user_id = ? AND hashtags.id = ?", current_user.id, params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @hashtag
  end
end
