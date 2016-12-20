class Battle < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags
  accepts_nested_attributes_for :hashtags, :reject_if => lambda { |h| h[:name].blank? }
  validates :hashtags, length: { minimum: 2, maximum: 5, too_long: "%{count} is the maximum number of hashtags", too_short: "%{count} is the minimum number of hashtags" }

  # Update Hashtags linked to Battle using User token
  def update_hashtags(at: Time.now)
    hashtags.each do |h|
      count, last_tweet_id = TwitterInterface.query_hashtag(user, h.name, at, h.get_last_tweet_id)
      h.update_count(add: count, last_tweet_id: last_tweet_id, at: at)
    end
  end

  def display_name
    hashtags.map(&:name).join(' vs ')
  end

end
