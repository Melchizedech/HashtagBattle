FactoryGirl.define do
  factory :battle do
    user
    created_at 5.days.ago.beginning_of_day

    factory :battle_with_hashtags do
      transient do
        hashtag_count 5
      end

      after(:build) do |battle, evaluator|
        build_list(:hashtag, evaluator.hashtag_count, battles: [battle])
      end
    end
  end
end