FactoryGirl.define do
  factory :hashtag do
    sequence(:name) { |n| '#notfamous' + n.to_s}
    created_at Time.now
    factory :famous_hashtag do
      transient do
        daily_hashtag_counts_count 5
      end

      after(:create) do |hashtag, evaluator|
        create_list(:daily_hashtag_count, evaluator.daily_hashtag_counts_count, hashtag: hashtag)
      end
    end

    factory :old_hashtag do
      transient do
        old_hashtag_counts_count 5
      end

      after(:create) do |hashtag, evaluator|
        create_list(:old_hashtag_count, evaluator.old_hashtag_counts_count, hashtag: hashtag)
      end
    end
  end
end