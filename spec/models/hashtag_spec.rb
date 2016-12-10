require "rails_helper"

RSpec.describe Hashtag, :type => :model do
  it "creates a hashtag" do
    Hashtag.create!(name: '#thisIsAHashtag')
    Hashtag.create!(name: '#h4sht46W1thNumb3rs')
  end

  it "fails to create a hashtag" do
    expect {Hashtag.create!(name: '#Hashtag_with_underscores').to raise_error(ActiveRecord::RecordInvalid)}
    expect {Hashtag.create!(name: '#Hashtag-with-dashes').to raise_error(ActiveRecord::RecordInvalid)}
    expect {Hashtag.create!(name: '#Hashtag-with-pun\'ctuati"on!').to raise_error(ActiveRecord::RecordInvalid)}
  end

  it "returns the total count of a hashtag" do
    hashtag = create(:famous_hashtag)
    expect(hashtag.get_total_count).to be(500)

    hashtag = create(:hashtag)
    expect(hashtag.get_total_count).to be(0)
  end

  it "returns the count for a certain amount of time" do
    hashtag = create(:hashtag)
    expect(hashtag.get_count_between(before: 3.days.ago, now: Time.now)).to be(0)

    5.times { create(:old_hashtag_count, hashtag: hashtag) }
    expect(hashtag.get_count_between(before: 3.days.ago, now: Time.now)).to be(300)
    expect(hashtag.get_count_between(before: 5.days.ago, now: 2.days.ago)).to be(400)
  end

  it "changes the count of the hashtag for the day" do
    hashtag = create(:hashtag)

    expect(hashtag.get_count_between).to be(0)
    hashtag.update_count(count: 5)
    hashtag.reload
    expect(hashtag.get_count_between).to be(5)
    hashtag.update_count(count: 15)
    expect(hashtag.get_count_between).to be(15)

    hashtag.update_count(count: 5, at: Date.yesterday.noon)
    expect(hashtag.get_count_between).to be(15)
    expect(hashtag.get_count_between(before: Date.yesterday.beginning_of_day)).to be(20)

  end
end
