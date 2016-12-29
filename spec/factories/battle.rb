FactoryGirl.define do
  factory :battle do
    user
    created_at 5.days.ago.beginning_of_day

    factory :battle_with_hashtags do
      transient do
        hashtag_count 5
      end

      before(:save) do |battle, evaluator|
        create_list(:hashtag, evaluator.hashtag_count, battles: [])
      end
    end
  end
end