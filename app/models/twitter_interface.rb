# This class implements the requests that should 
# be done to Twitter to be able to authenticate
# users with Twitter credentials
class TwitterInterface
  attr_reader :last_tweet_id

  def self.configure
    @@oauth ||= YAML.load_file(TWITTER)
  end

  def initialize(user)
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = @@oauth[:consumer_key]
      config.consumer_secret     = @@oauth[:consumer_secret]
      config.access_token        = user.access_token
      config.access_token_secret = user.secret_access_token
    end
    self
  end
 
  def fetch_tweet_count(hashtag, at)
    @last_tweet_id = hashtag.get_last_tweet_id
    results = @client.search(hashtag.name, 
                             until: at.tomorrow.to_date,
                             since: at.to_date,
                             max_id: @last_tweet_id
                            ).to_a
    @last_tweet_id = results.last.id if results.last
    results.size
  end
end
