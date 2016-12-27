require "rails_helper"

RSpec.describe TwitterInterface, :type => :model do

  it 'query a hashtag' do

    VCR.use_cassette('twitter_interface/query_hashtag') do
      user = build(:user)
      hashtag = build(:hashtag, name: '#qwerty')
      #client = TwitterInterface.new(user)
      #expect(client.stub(:fetch_tweet_count).with(hashtag, Time.now)).to be(2)
    end
  end
end