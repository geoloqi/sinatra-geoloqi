require 'sinatra'
require './lib/sinatra/geoloqi'

set :geoloqi_client_id,     '665a737a5abe1fac5cced7149f03a62b'
set :geoloqi_client_secret, '8245fc243b16dc3ed6a8b56e1d0d7526'
set :geoloqi_redirect_uri,  'http://127.0.0.1:4567'       if development?
set :geoloqi_redirect_uri,  'http://productionwebsite.com' if production?
set :session_secret,        'abcd'

before do
  require_geoloqi_login
end

get '/?' do
  username = geoloqi.get('account/username')['username']
  "You have successfully logged in as #{username}!"
end