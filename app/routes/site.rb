class Main
  before do
    logger.info("#{request.request_method} #{request.fullpath} #{params.inspect}")
  end

  get '/authenticated' do
    if twitter_user
      self.current_user = 
        User.find_or_create_by(twitter_user, session[:access_token])

      redirect user_url(current_user)
    else
      redirect root_url
    end
  end

  get '/logout' do
    twitter_logout
    self.current_user = nil
    redirect root_url
  end
end
