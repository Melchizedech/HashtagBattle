class Battle < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags
  accepts_nested_attributes_for :hashtags

  # Update Hashtags linked to Battle using User token
  def update_hashtags
    hashtags.each { |h| h.update_count(user: user, force: true) }
  end

end
