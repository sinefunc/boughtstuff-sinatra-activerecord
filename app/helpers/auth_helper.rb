class Main
  helpers do
    def login_required( redirect_to = '/' )
      unless logged_in?
        redirect redirect_to
      end
    end

    def logged_in?
      current_user.is_a?(User)
    end

    def current_user
      @current_user ||= (User.find_by_id(session[:user_id]) || AnonymousUser.new)
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
