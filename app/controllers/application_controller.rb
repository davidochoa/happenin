class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init_facebook_graph

  protected

  def init_facebook_graph
    init_facebook_user unless session[:fb_access_token]
    @graph = Koala::Facebook::API.new(session[:fb_access_token])
    @graph.debug_token(session[:fb_access_token])
  rescue Koala::Facebook::AuthenticationError,
      Koala::Facebook::ClientError => e
    reset_facebook_access_token(e)
    render 'home/facebook_login'
  end

  def init_facebook_user
    app_id = ENV['FB_APP_ID']
    app_secret = ENV['FB_APP_SECRET']
    oauth = Koala::Facebook::OAuth.new(app_id, app_secret)
    user_info = oauth.get_user_info_from_cookies(cookies)
    session[:fb_access_token] = user_info['access_token'] if user_info
  end

  def reset_facebook_access_token(e)
    return unless e && e.fb_error_type == 'OAuthException' &&
      e.fb_error_code == 190 && e.fb_error_subcode == 463
    session[:fb_access_token] = nil
    init_facebook_graph
  end
end
