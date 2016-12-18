class Hashtag < ActiveRecord::Base
  has_and_belongs_to_many :battles
  has_many :daily_hashtag_counts

  validates_format_of :name, :with => /[^\s[[:punct:]]]+/, message: 'Hashtag name must not contain punctuation nor whitespaces.'
  validates_format_of :name, :with => /\A#/, message: 'Hashtag name must start with a \'#\'.'

  # Gets count of hashtag retrieved for all the data we've got
  # Sums all the daily count for the hashtag
  def get_total_count
    daily_hashtag_counts.map(&:count).inject(0) { |sum, c| sum+=c }
  end

  # Gets count of hashtag between two dates
  # Sums all the daily count for the hashtag between the dates provided
  def get_count_between(before: Date.today.beginning_of_day, now: Date.today.end_of_day)
    daily_hashtag_counts.where(last_refresh: before.beginning_of_day..now.end_of_day).map(&:count).inject(0) { |sum, c| sum+=c }
  end

  # Sets the count for the hashtag at a given moment
  # Updates the daily_count or create one if it doesn't exist yet
  # Using battle's user credentials
  def update_count(user:, at: Time.now, count: 0)
    daily_count = daily_hashtag_counts.where("last_refresh between ? and ?", at.beginning_of_day, at.end_of_day).first || DailyHashtagCount.new(hashtag: self, count: 0)
    # Update if the count is not fresh or if it's the last update for the day
    return if daily_count.is_fresh?(at: at) && at != at.end_of_day
    count = TwitterInterface.query_hashtag(user, name, at)
    daily_count.last_refresh = at
    # Do not save a smaller value than what we've already got
    daily_count.count = count if count > daily_count.count
    daily_count.save!
  end
end
