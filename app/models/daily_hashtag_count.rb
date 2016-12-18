class DailyHashtagCount < ActiveRecord::Base
  belongs_to :hashtag

  # A count is fresh *enough* if it has been refreshed less than 5 minutes ago
  def is_fresh?(at: Time.now)
    last_refresh && (last_refresh - at) < 5.minutes
  end
end
