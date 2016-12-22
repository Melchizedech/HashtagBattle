class HashtagController < ApplicationController
  include ApplicationHelper

  before_action :require_login

  # List of hashtags used by logged user
  def index
    @hashtags = Hashtag.joins(:battles).where("battles.user_id = ?", current_user.id).includes(:battles).distinct
  end

  # Get a hashtag used by logged user
  def show
    @hashtag = Hashtag.joins(:battles).where("battles.user_id = ? AND hashtags.id = ?", current_user.id, params[:id]).first
    raise ActiveRecord::RecordNotFound.new('Not Found') unless @hashtag
  end

  # Update a hashtag using logged user credential
  def update_count
    hashtag = Hashtag.joins(:battles).where("battles.user_id = ? AND hashtags.id = ?", current_user.id, params[:id]).first
    raise ActiveRecord::RecordNotFound.new('Not Found') unless hashtag    
    at = Time.now

    count, last_tweet_id = TwitterInterface.query_hashtag(current_user, hashtag.name, at, hashtag.get_last_tweet_id)

    hashtag.update_count(add: count, last_tweet_id: last_tweet_id)
    render nothing: true, status: 204, content_type: 'text/html' 
  end

  # Get Evolution Chart data of hashtag
  def evolution_chart_data
    hashtag = Hashtag.joins(:battles).where("battles.user_id = ? AND hashtags.id = ?", current_user.id, params[:hashtag_id]).first

    raise ActiveRecord::RecordNotFound.new('Not Found') unless hashtag   

    result = [hashtag.get_stacked_evolution_data(from: hashtag.created_at)]
    
    render json: result
  end

end
