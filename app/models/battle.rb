class Battle < ActiveRecord::Base
  belongs_to :user
  has_many :hashtags

  def update_hashtags
    hashtags.each { |h| h.update_count }
  end

end
