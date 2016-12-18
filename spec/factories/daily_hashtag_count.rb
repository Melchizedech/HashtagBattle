FactoryGirl.define do
  factory :daily_hashtag_count do
    count 100
    sequence(:last_tweet_id) { |n| n.to_s}
    hashtag
    last_refresh Time.now

    factory :old_hashtag_count do
      sequence(:last_refresh) { |n| n.days.ago }
    end
  end
end