class Main
  helpers do
    def root_url
      '/'  
    end
    
    def user_url( user )
      '/%s/items' % user.username
    end

    def new_item_path
      '/items/new' 
    end

    def everyones_items_url
      '/%s/items' % AnonymousUser::USERNAME
    end

    def item_path( item )
      '/%s/%s' % [ item.user.username, item.to_param ]
    end

    def new_reply_path(options = {})
      append_query_string("/replies/new", options)
    end

    def retweets_path(options = {})
      append_query_string("/retweets", options) 
    end

    def most_viewed_url
      '/%s/most-viewed' % AnonymousUser::USERNAME
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
  
    def tagged_items_path( user, tag )
      '/%s/tagged/%s' % [ user.username, tag ]
    end

    def liked_path( user )
      case user
      when User
        '/%s/liked' % user.username
      else
        '/%s/liked' % AnonymousUser::USERNAME
      end
    end

    def like_path( item_id )
      raise TypeError unless Fixnum === item_id
      '/likes/%s' % item_id
    end

    def likes_path( options = {} )
      append_query_string( "/likes", options ) 
    end

    def friends_items_path( user )
      '/%s/friends-items' % user.username
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
