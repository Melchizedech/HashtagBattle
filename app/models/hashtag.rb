class Hashtag < ActiveRecord::Base
  has_and_belongs_to_many :battles
  has_many :daily_hashtag_counts

  validates_format_of :name, :with => /[^\s[[:punct:]]]+/, message: 'Hashtag name must not contain punctuation nor whitespaces.'
  validates_format_of :name, :with => /\A#/, message: 'Hashtag name must start with a \'#\'.'

  # Gets count of hashtag retrieved for all the data we've got
  # Sums all the daily count for the hashtag
  def get_total_count
    daily_hashtag_counts.map(&:count).inject(0) { |sum, c| sum += c }
  end

  # Gets count of hashtag between two dates
  # Sums all the daily count for the hashtag between the dates provided
  def get_count_between(before: Date.today.beginning_of_day, now: Date.today.end_of_day)
    daily_hashtag_counts.where(last_refresh: before.beginning_of_day..now.end_of_day).map(&:count).inject(0) { |sum, c| sum += c }
  end

  def get_last_tweet_id(at: Time.now)
    dhc = daily_hashtag_counts.where(last_refresh: at.beginning_of_day..at.end_of_day).first
    dhc.try(:last_tweet_id)
  end

  def get_stacked_evolution_data(from: Date.today)
    data        = {}
    data[:name] = name
    data[:data] = []
    daily_hashtag_counts.where(last_refresh: [from..Time.now]).each do |dhc|
      data[:data] << [dhc.count, dhc.last_refresh.strftime('%d-%m-%Y')]
    end

    sum = 0
    data[:data].map! { |c| [c[1], sum += c[0]] }.to_h
    data
  end

  # Sets the count for the hashtag at a given moment
  # Updates the daily_count or create one if it doesn't exist yet
  # Using battle's user credentials
  def update_count(add: 0, at: Time.now, last_tweet_id: nil)
    daily_count               = daily_hashtag_counts.where(last_refresh: at.beginning_of_day..at.end_of_day).first || DailyHashtagCount.new(hashtag: self, count: 0)
    daily_count.last_refresh  = at
    daily_count.last_tweet_id = last_tweet_id
    daily_count.count        += add
    daily_count.save!
  end
end
