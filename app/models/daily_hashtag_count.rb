class DailyHashtagCount < ActiveRecord::Base
  belongs_to :hashtag

  # A count is fresh *enough* if it has been refreshed less than 5 minutes ago
  def is_fresh?(at: Time.now)
    last_refresh && (at - last_refresh) < 5.minutes
  end
end
