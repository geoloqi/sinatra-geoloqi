require 'sinatra/base'
require 'geoloqi'

module Sinatra
  module Geoloqi
    # Registers the Geoloqi plugin. This call is required for classy apps which inherit Sinatra::Base, and not required for classic apps.
    def self.registered(app)
      app.enable :sessions unless app.test?

      app.after do
        session[:_geoloqi_auth] = @_geoloqi.auth unless session[:_geoloqi_auth].nil? && @_geoloqi.nil?
      end

      app.helpers do
        # Instantiate (or retrieve) the current Geoloqi session.
        #
        # @return [Geoloqi::Session]
        def geoloqi
          @_geoloqi ||= ::Geoloqi::Session.new :auth => session[:_geoloqi_auth],
                                               :config => {:client_id => settings.geoloqi_client_id,
                                                           :client_secret => settings.geoloqi_client_secret}
        end

        # Redirects to Geoloqi OAuth2 authentication if the user is not logged in. Use this to force login for routes.
        def require_geoloqi_login
          geoloqi.get_auth(params[:code], settings.geoloqi_redirect_uri) if params[:code] && !geoloqi.access_token?
          redirect geoloqi.authorize_url(settings.geoloqi_redirect_uri) unless geoloqi.access_token?
        end
      end
    end
  end

  register Geoloqi
end