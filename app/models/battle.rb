class Battle < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags
  accepts_nested_attributes_for :hashtags

  # Update Hashtags linked to Battle using User token
  def update_hashtags(at: Time.now)
    hashtags.each do |h|
      count, last_tweet_id = TwitterInterface.query_hashtag(user, h.name, at, h.get_last_tweet_id)
      h.update_count(add: count, last_tweet_id: last_tweet_id, at: at)
    end
  end

end
