require "rails_helper"

RSpec.describe TwitterInterface, :type => :model do

  it 'queries a hashtag' do

    VCR.use_cassette('twitter_interface/query_hashtag') do
      user = build(:user)
      hashtag = build(:hashtag, name: '#qwerty')
      client = TwitterInterface.new(user)
      expect(client.fetch_tweet_count(hashtag, Time.now)).to be(2)
      response = JSON.parse(YAML.load(File.read('spec/vcr/twitter_interface/query_hashtag.yml'))['http_interactions'][0]['response']['body']['string'])
      expect(client.last_tweet_id).to be(response['statuses'].last['id'])
    end
  end
end