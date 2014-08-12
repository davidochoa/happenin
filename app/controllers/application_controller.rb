class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init_facebook_graph
  before_filter :init_eventbrite

  protected

  def init_facebook_graph
    init_facebook_user unless session[:fb_access_token]
    app_access_token = "#{ENV['FB_APP_ID']}|#{ENV['FB_APP_SECRET']}"
    graph = Koala::Facebook::API.new(app_access_token)
    graph.debug_token(session[:fb_access_token])
    @fb_graph = Koala::Facebook::API.new(session[:fb_access_token])
  rescue Koala::Facebook::AuthenticationError,
         Koala::Facebook::ClientError => e
    handle_facebook_error(e)
  end

  def init_facebook_user
    app_id = ENV['FB_APP_ID']
    app_secret = ENV['FB_APP_SECRET']
    oauth = Koala::Facebook::OAuth.new(app_id, app_secret)
    user_info = oauth.get_user_info_from_cookies(cookies)
    session[:fb_access_token] = user_info['access_token'] if user_info
  end

  def handle_facebook_error(e)
    if e && e.fb_error_type == 'OAuthException' && e.fb_error_code == 190 &&
      e.fb_error_subcode == 463
      session[:fb_access_token] = nil
      init_facebook_graph
    else
      render 'home/facebook_login'
    end
  end

  def init_eventbrite
    @ebrite = EventbriteClient.new(app_key: ENV['EVENTBRITE_APP_ID'])
  end
end
