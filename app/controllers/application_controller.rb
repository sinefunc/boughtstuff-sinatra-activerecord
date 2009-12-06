# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  filter_parameter_logging :password
  
  before_filter :authenticate
  
  def self.no_login_required
    skip_before_filter :authenticate
  end
  
  private
    def authenticate
      return if params[:controller] == 'sessions'
      
      login_required
    end
end
