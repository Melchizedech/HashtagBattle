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

  def update_count_for_battle
    @battle = Battle.find(params[:battle_id])
    @hashtag = @battle.hashtags.find(params[:hashtag_id])
    at = Time.now
    count, last_tweet_id = TwitterInterface.query_hashtag(current_user, @hashtag.name, at, @hashtag.get_last_tweet_id)
    @hashtag.update_count(add: count, last_tweet_id: last_tweet_id)
    render layout: false
  end
end
