class Main
  helpers do
    def root_url( options = {} )
      if options.empty?
        '/'  
      elsif options[:host]
        options[:host]
      end
    end
    
    def user_url( user )
      account_url(user.username) + '/items'
    end

    def new_item_path
      '/items/new' 
    end

    def everyone_items_url
      account_url('www') + '/items'
    end

    def absolute_item_url( item )
      account_url(item.user.username) + '/items/' + item.to_param 
    end

    def item_path( item )
      '/items/' + item.to_param
    end

    def new_reply_path(options = {})
      append_query_string("/replies/new", options)
    end

    def retweets_path(options = {})
      append_query_string("/retweets", options) 
    end

    def most_viewed_url
      '/most-viewed'
    end

    def login_url
      '/login'
    end

    def logout_url
      '/logout'
    end

    def items_path
      '/items'
    end
  
    def tagged_items_path( tag )
      '/items/tagged/' + tag
    end

    def liked_path
      '/liked'
    end

    def like_path( item )
      '/likes/' + item.to_s
    end

    def likes_path( options = {} )
      append_query_string( "/likes", options ) 
    end

    def friends_items_path
      '/friends-items' 
    end

    private
      def append_query_string( path, options )
        path.dup.tap do |p|
          if options.any?
            p << '?'
            p << options.map { |k, v| 
              %(#{k}=#{v.respond_to?(:to_param) ? v.to_param : v}) }.join('&')
          end
        end
      end
  end
end
