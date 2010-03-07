class Main
  helpers do
    def logged_in?
      current_user.is_a?(User)
    end

    def current_user
      @current_user ||= (User.find_by_login(session[:user_id]) || Anonymous.new)
    end

    def current_user=( user )
      if User === user
        session[:user_id] = user.id
        @current_user = user
      else
        session[:user_id] = nil
        @current_user = nil
      end
    end

    def logged_in
      yield if logged_in?  
    end

    def logged_out
      yield if not logged_in?
    end
  end
end
