FactoryGirl.define do
  factory :hashtag do
    name '#notfamous'

    factory :famous_hashtag do
      transient do
        daily_hashtag_counts_count 5
      end

      after(:create) do |hashtag, evaluator|
        create_list(:daily_hashtag_count, evaluator.daily_hashtag_counts_count, hashtag: hashtag)
      end
    end
  end
end