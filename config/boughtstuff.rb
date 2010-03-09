module Boughtstuff
  SITE_TITLE    = "Boughtstuff ~ social spending at its finest"
  SITE_NAME     = "Boughtstuff"
  SITE_SUBTITLE = "social spending at its finest"

  HOST = 
    case RACK_ENV
    when 'development', 'test', 'cucumber' then 'boughtstuff.local:4567'
    when 'production' then 'www.boughtstuff.com'
  end
  
  ASSET_HOST =
    case RACK_ENV
    when 'development', 'test', 'cucumber' then 'http://boughtstuff.local:3000'
    when 'production' then "http://d20r1yy71waydm.cloudfront.net"
    end

  SESSION_DOMAIN = 
    case RACK_ENV
    when 'development', 'test', 'cucumber' then '.boughtstuff.local'
    when 'production' then '.boughtstuff.com'
    end
  
  SESSION_SECRET =  
    "2Lf2oD8WS95aejGIvhlemC4mi5rvhAsAhruL27ljwTlHOwjtCockeGzx8VZqVdf" #+ 
    # "41T32ncFBI0okbcl0pkf9g6RjECkxZ7WGzrDxF4EqijprZ9kwPfWjXwqg7NAoMP" +
    # "5WGVauBh5nAhmRHJWLVLY2BjMBM67IlZPDSx1VhiYud4A0flheV4eaxWuUsDLxY"
  
  SESSION_OPTIONS = {
#    key:    'rack.session',
    path:   '/',
    domain: SESSION_DOMAIN#,
#    secret: SESSION_SECRET
  }

  TWITTER_LOGIN_OPTIONS = {
    consumer_key: "2YTK8XIszlR12aVju0tA", 
    secret:       "lcO2ulMC2dhAS1dvEQz7qT4fCsMFKDrqpF9BSyw2A8",
    return_to:    "/authenticated"
  }
end
