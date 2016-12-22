class DailyHashtagCount < ActiveRecord::Base
  belongs_to :hashtag

  ###         ATTRIBUTES       ###
  ### INT      count           ###
  ### DATETIME last_refresh_at ###
  ### STRING   last_tweet_id   ###
end
