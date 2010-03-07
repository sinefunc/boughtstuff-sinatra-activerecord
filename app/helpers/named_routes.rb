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
      account_url(user.username)
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
      ret = "/replies/new"
      if options.any?
        ret << '?'
        ret << options.map { |k, v| %(#{k}=#{v}) }.join('&')
      end
      ret
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

    def friends_items_path
      '/friends-items' 
    end
  end
end
