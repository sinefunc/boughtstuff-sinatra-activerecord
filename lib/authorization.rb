module Sinatra
  module Authorization
    USER = 'drF2mX5RAK8wUuEyyyYpuiCC0EEHUpFXvAWr6asd1iKHC6H9tvL57LI3n04EZEp'
    PASS = 'XsDytWvA5WYG5Yw9mTB8gclsYIPbaxPK9jI4MDHjTR64ycXJfbvgeZDaGPaTCqS'

    def auth
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
    end
   
    def unauthorized!(realm="API")
      headers 'WWW-Authenticate' => %(Basic realm="#{realm}")
      throw :halt, [ 401, 'Authorization Required' ]
    end
   
    def bad_request!
      throw :halt, [ 400, 'Bad Request' ]
    end
   
    def authorized?
      request.env['REMOTE_USER']
    end
   
    def authorize(user, pass)
      user == USER && pass == PASS
    end
   
    def require_api_user
      return if authorized?
      unauthorized!   unless auth.provided?
      bad_request!    unless auth.basic?
      unauthorized!   unless authorize(*auth.credentials)

      request.env['REMOTE_USER'] = auth.username
    end
  end
end

