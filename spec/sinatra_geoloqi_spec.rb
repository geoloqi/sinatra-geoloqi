ENV['RACK_ENV'] = 'test'
require File.join(File.join(File.expand_path(File.dirname(__FILE__))), '..', 'lib', 'sinatra', 'geoloqi')
require 'rack/test'
require 'minitest/autorun'
require 'wrong/adapters/minitest'
require 'webmock'
Wrong.config.alias_assert :expect_that

include WebMock::API

def auth
  {'display_name' => 'Captain Ron',
   'username' => 'isthegreatestmoviever',
   'user_id' => '31337',
   'is_anonymous' => 0,
   'access_token' => 'access_token1234',
   'scope' => nil,
   'expires_in' => 3600,
   'refresh_token' => 'refresh_token1234'}
end

def app
  @app ||= Sinatra.new do
    set :geoloqi_client_id,     'ABCD'
    set :geoloqi_client_secret, 'EFGH'
    set :geoloqi_redirect_uri,  'http://example.org/test'
    
    register Sinatra::Geoloqi

    get '/' do
      geoloqi.class.to_s
    end

    get '/redirect' do
      require_geoloqi_login
    end

    get '/test' do
      require_geoloqi_login
      geoloqi.access_token
    end
    
    get '/calltest' do
      require_geoloqi_login
      geoloqi.get('account/profile')['result']
    end
  end
end

describe 'A mock app' do
  include Rack::Test::Methods

  it 'returns geoloqi object' do
    get '/'
    expect_that { last_response.ok? }
    expect_that { last_response.body == 'Geoloqi::Session' }
  end

  it 'returns a geoloqi object on request' do
    get '/redirect'
    expect_that { last_response.redirect? }
    expect_that { last_response.headers['Location'] == 'https://geoloqi.com/oauth/authorize?response_type=code&client_id=ABCD&redirect_uri=http%3A%2F%2Fexample.org%2Ftest' }
  end

  it 'processes the geoloqi return' do
    stub_request(:post, "https://api.geoloqi.com/1/oauth/token").
      with(:body => "{\"client_id\":\"ABCD\",\"client_secret\":\"EFGH\",\"grant_type\":\"authorization_code\",\"code\":\"code1234\",\"redirect_uri\":\"http://example.org/test\"}").
      to_return(:status => 200,
                :body => auth.to_json)
    
    get '/test?state=&code=code1234'
    expect_that { last_response.ok? }
    expect_that { last_response.body == 'access_token1234' }
  end

  it 'calls successfully' do
    stub_request(:get, "https://api.geoloqi.com/1/account/profile").
      with(:headers => {'Authorization' => 'OAuth access_token1234'}).
      to_return(:status => 200, :body => {'result' => 'ok'}.to_json, :headers => {})
    
    get '/calltest', {}, 'rack.session' => {:'_geoloqi_auth' => auth}

    expect_that { last_response.status == 200 }
    expect_that { last_response.body == 'ok' }
  end
end