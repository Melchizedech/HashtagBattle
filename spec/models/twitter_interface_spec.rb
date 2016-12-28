require "rails_helper"

RSpec.describe TwitterInterface, :type => :model do

  it 'queries a hashtag' do
    VCR.use_cassette('twitter_interface/query_hashtag') do
      user       = build(:user)
      hashtag    = build(:hashtag, name: '#qwerty')
      request    = YAML.load(File.read('spec/vcr/twitter_interface/query_hashtag.yml'))

      # Get the right date according to the cassette...
      date       = request['http_interactions'][0]['request']['uri'].match(/.*since=([^&]*)/)[1].to_date
      
      Delorean.time_travel_to date do
        client   = TwitterInterface.new(user)
        expect(client.fetch_tweet_count(hashtag, Time.now)).to be(2)
        response = JSON.parse(request['http_interactions'][0]['response']['body']['string'])
        expect(client.last_tweet_id).to be(response['statuses'].last['id'])
      end
    end
  end
end