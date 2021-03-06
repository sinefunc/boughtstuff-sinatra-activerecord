class Main
  get '/authenticated' do
    if twitter_user
      self.current_user = 
        User.find_or_create_by(twitter_user, session[:access_token])

      if session[:return_to]
        redirect session.delete(:return_to)
      else     
        redirect user_url(current_user)
      end
    else
      redirect root_url
    end
  end

  get '/logout' do
    twitter_logout
    self.current_user = nil
    redirect root_url
  end

  post '/session/state' do
    username = URI.parse(request.referer).path.gsub(%r{^/}, '').split('/').first
    @account = User.find_by_username( username )

    haml :'session/state', :layout => false
  end
end
