class Main
  helpers do
    def self?( user )
      current_user && current_user == user
    end

    def user_avatar( user )
      image_tag user.avatar_url, :alt => user.name
    end

    def user_link_to( user, options = {} )
      link_to h(user.name), user_url(user), options
    end
  end
end
