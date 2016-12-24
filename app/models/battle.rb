class Battle < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags
  accepts_nested_attributes_for :hashtags, :reject_if => lambda { |h| h[:name].blank? }
  validates :hashtags, length: { minimum: 2, maximum: 5, too_long: "%{count} is the maximum number of hashtags", too_short: "%{count} is the minimum number of hashtags" }

  # Update Hashtags linked to Battle using User token
  def update_hashtags(at: Time.now)
    hashtags.each do |h|
       twitter = TwitterInterface.new(user)
       count = twitter.fetch_tweet_count(h, at)
       last_tweet_id = twitter.last_tweet_id
       h.update_count(add: count, last_tweet_id: last_tweet_id, at: at)
    end
  end

  # Get Battle name using its hashtags
  def display_name
    hashtags.map(&:name).join(' vs ')
  end

end
