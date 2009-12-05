class TimelineController < ApplicationController
  # this requires us to log in through Twitter before accessing any actions here
  before_filter :login_required

  def index  
    @tweets = current_user.twitter.get('/statuses/friends_timeline')
  end
end