# This class implements the requests that should 
# be done to Twitter to be able to authenticate
# users with Twitter credentials
class TwitterInterface

  class << self
    def configure
      @oauth ||= YAML.load_file(TWITTER)
    end

    # See https://dev.twitter.com/docs/auth/implementing-sign-twitter (Step 1)
    def request_token

      # The request to get request tokens should only
      # use consumer key and consumer secret, no token
      # is necessary
      response = TwitterInterface.request(
        :post, 
        "https://api.twitter.com/oauth/request_token",
        {},
        @oauth
      )

      obj  = {}
      vars = response.body.split("&").each do |v|
        obj[v.split("=").first] = v.split("=").last
      end

      return [obj["oauth_token"], obj["oauth_token_secret"]]
    end

    # See https://dev.twitter.com/docs/auth/implementing-sign-twitter (Step 2)
    def authenticate_url(query) 
      # The redirection need to be done with oauth_token
      # obtained in request_token request
      "https://api.twitter.com/oauth/authenticate?oauth_token=" + query
    end

    # See https://dev.twitter.com/docs/auth/implementing-sign-twitter (Step 3)
    def access_token(oauth_token, oauth_token_secret, oauth_verifier)

      # To request access token, you need to retrieve
      # oauth_token and oauth_token_secret stored in 
      # database

      # now the oauth signature variables should be
      # your app consumer keys and secrets and also
      # token key and token secret obtained in request_token
      oauth                = @oauth.dup
      oauth[:token]        = oauth_token
      oauth[:token_secret] = oauth_token_secret

      # oauth_verifier got in callback must 
      # to be passed as body param
      response = TwitterInterface.request(
        :post, 
        "https://api.twitter.com/oauth/access_token",
        {:oauth_verifier => oauth_verifier},
        oauth
      )

      obj  = {}
      vars = response.body.split("&").each do |v|
        obj[v.split("=").first] = v.split("=").last
      end

      return [obj["oauth_token"], obj["oauth_token_secret"]]
    end
    

    # get the count of a Hashtag, using the tokens of 'user'
    def query_hashtag(user, hashtag, date, last_tweet_id)
      search_query  = '?q=' + hashtag + ' ' + '&since=' + date.strftime('%Y-%m-%d') + ' ' + '&until=' + date.tomorrow.strftime('%Y-%m-%d') + '&count=100'
      search_query += '&since_id=' + last_tweet_id if last_tweet_id
      search_query  = URI.encode(search_query)
      base_uri      = 'https://api.twitter.com/1.1/search/tweets.json'

      # see that now we use the app consumer variables
      # plus user access token variables to sign the request
      tokens = { access_token: user.access_token, access_token_secret: user.secret_access_token }

      count = 0
      loop do
        result        = query(tokens, base_uri+search_query)
        break unless result['search_metadata'] && result['search_metadata']['count'] && result['search_metadata']['max_id']
        count        += result['statuses'].size
        search_query  = result['search_metadata']['next_results']
        last_tweet_id = result['search_metadata']['max_id']
        break unless result['search_metadata']['next_results']
      end

      [count, last_tweet_id]
    end

    # This is a sample Twitter API request to 
    # make usage of user Access Token
    # See https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials
    def verify_credentials(access_token, access_token_secret)
      # see that now we use the app consumer variables
      # plus user access token variables to sign the request
      tokens = { access_token: access_token, access_token_secret: access_token_secret }
      query(tokens, "https://api.twitter.com/1.1/account/verify_credentials.json")
    end

    def query(tokens, uri)
      oauth                = @oauth.dup
      oauth[:token]        = tokens[:access_token]
      oauth[:token_secret] = tokens[:access_token_secret]

      response = TwitterInterface.request(
        :get, 
        uri,
        {},
        oauth
      )

      result = JSON.parse(response.body)
      return result      
    end

    # Generic request method used by methods above
    def request(method, uri, params, oauth)
      uri = URI.parse(uri.to_s)

      # always use SSL, you are dealing with other users data
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      # uncomment line below for debug purposes
      #http.set_debug_output($stdout)

      req         = (method == :post ? Net::HTTP::Post : Net::HTTP::Get).new(uri.request_uri)
      req.body    = params.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
      req["Host"] = "api.twitter.com"

      # Oauth magic is done by simple_oauth gem.
      # This gem is enable you to use any HTTP lib
      # you want to connect in OAuth enabled APIs.
      # It only creates the Authorization header value for you
      # and you can assign it wherever you want
      # See https://github.com/laserlemon/simple_oauth
      req["Authorization"] = SimpleOAuth::Header.new(method, uri.to_s, params, oauth)
      http.request(req)
    end

  end
end