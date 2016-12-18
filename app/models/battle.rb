class Battle < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags
  accepts_nested_attributes_for :hashtags

  # Update Hashtags linked to Battle using User token
  def update_hashtags(at: Time.now)
    hashtags.each { |h| h.update_count(user: user, at: at) }
  end

end
