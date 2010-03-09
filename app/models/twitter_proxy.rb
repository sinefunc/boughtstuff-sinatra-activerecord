class TwitterProxy
  class Unauthorized < StandardError; end
  class Error < StandardError; end

  def initialize( user )
    @user = user 
  end
  
  [ :get, :put, :delete, :post, :head ].each do |meth|
    if RACK_ENV == 'development' and not [ :get ].include?(meth)
      define_method meth do |path, *arguments|
        logger.info "#{meth}, #{path}, #{arguments.inspect}"
        puts "#{meth}, #{path}, #{arguments.inspect}"
        { "id" => 654321 }
      end
    else
      define_method meth do |path, *arguments|
        request( meth, path, *arguments )
      end
    end
  end

  def post!(status)
    post('/statuses/update.json', :status => status)
  end

  private
    def request( request_method, path, *arguments )
      response = client.send request_method, append_extension_to(path), *arguments 
      handle_response(response)
    end

    def client
      oauth = twitter_oauth
      oauth.authorize_from_access(@user.access_token, @user.access_secret)
      Twitter::Base.new oauth
    end

    def twitter_oauth
      Twitter::OAuth.new(
        *settings(:twitter).values_at(:consumer_key, :secret)
      )
    end
  
    def append_extension_to(path)
      path, query_string = *(path.split("?"))
      path << '.json' unless path.match(/\.(:?xml|json)\z/i)
      "#{path}#{"?#{query_string}" if query_string}"
    end

    def handle_response(response)
      case response
      when Net::HTTPOK 
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          response.body
        end
      when Net::HTTPUnauthorized
        raise Unauthorized, 'The credentials provided did not authorize the user.'
      else
        message = begin
          JSON.parse(response.body)['error']
        rescue JSON::ParserError
          if match = response.body.match(/<error>(.*)<\/error>/)
            match[1]
          else
            'An error occurred processing your Twitter request.'
          end
        end

        raise Error, message
      end
    end
end
