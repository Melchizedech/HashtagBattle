FactoryGirl.define do
  factory :battle do
    user
    created_at 5.days.ago.beginning_of_day

    factory :battle_with_hashtags do
      transient do
        hashtag_count 5
        counts_count 5
      end

      after(:create) do |hashtag, evaluator|
        create_list(:hashtag, evaluator.hashtag_count, battle: battle)
      end
    end
  end
end