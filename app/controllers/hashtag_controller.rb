class HashtagController < ApplicationController
  include ApplicationHelper

  before_action :require_login, only: [:update_count, :user_hashtags]

  # List of hashtags
  def index
    @hashtags = Hashtag.all
    @user = current_user
  end

  # List of hashtags used by logged user
  def user_hashtags
    @hashtags = Hashtag.joins(:battles).where("battles.user_id = ?", current_user.id).includes(:battles).distinct
  end

  # Get a hashtag used
  def show
    @hashtag = Hashtag.find(params[:id])
    @user = current_user
  end

  # Update a hashtag using logged user credential
  def update_count
    hashtag = Hashtag.find(params[:id])
    at = Time.now

    count, last_tweet_id = TwitterInterface.query_hashtag(current_user, hashtag.name, at, hashtag.get_last_tweet_id)

    hashtag.update_count(add: count, last_tweet_id: last_tweet_id)
    render nothing: true, status: 204, content_type: 'text/html' 
  end

  # Get Evolution Chart data of hashtag
  def evolution_chart_data
    hashtag = Hashtag.find(params[:hashtag_id])
    result  = [hashtag.get_stacked_evolution_data(from: hashtag.created_at)]
    
    render json: result
  end

end
