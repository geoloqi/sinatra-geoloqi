Geoloqi plugin for Sinatra [![](https://secure.travis-ci.org/geoloqi/sinatra-geoloqi.png)](http://travis-ci.org/geoloqi/sinatra-geoloqi)
===
Easy drop-in [Sinatra](http://sinatrarb.com) plugin for Geoloqi. All you need to do is require it, configure the settings and you're ready to go with Geoloqi application development!

Installation
---

    gem install sinatra-geoloqi

Usage
---
First, go to the [Geoloqi Developers Site](https://developers.geoloqi.com) and create an application on the "Your Apps" page.

Then, you can use it like this. This is the standard way with classic mode:

    require 'sinatra'
    require 'sinatra/geoloqi'
    
    set :geoloqi_client_id,     'YOUR_APP_ID_GOES_HERE'
    set :geoloqi_client_secret, 'YOUR_APP_SECRET_GOES_HERE'
    set :geoloqi_redirect_uri,  'http://127.0.0.1:4567'
    set :session_secret,        'ENTER_RANDOM_TEXT_HERE'
    
    before do
      require_geoloqi_login
    end
    
    get '/?' do
      username = geoloqi.get('account/username')['username']
      "You have successfully logged in as #{username}!"
    end

For "classy mode", don't forget to register the plugin explicitly:

    register Sinatra::Geoloqi

Found a bug?
---
Let us know! Send a pull request or a patch. Questions? Ask! We're here to help. File issues, we'll respond to them!

Authors
---
* [Kyle Drake](https://github.com/kyledrake)
