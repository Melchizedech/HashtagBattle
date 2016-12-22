require "rails_helper"

RSpec.describe Battle, :type => :model do
  it "creates a battle" do
    battle = build(:battle)
    4.times { |n| battle.hashtags << Hashtag.new(name: '#HashtagBattle#{n}') }
    expect(battle.save).to be(true)
  end

  it "fails to create a battle" do
    battle = build(:battle)
    battle.hashtags << Hashtag.new(name: '#aGoodHashtag')
    expect(battle.save).to be(false)
    6.times { |n| battle.hashtags << Hashtag.new(name: '#anotherGoodHashtag#{n}') }
    expect(battle.save).to be(false)
  end
end
