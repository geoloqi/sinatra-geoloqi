Gem::Specification.new do |s|
  s.name = 'sinatra-geoloqi'
  s.version = '0.9.3'
  s.authors = ['Kyle Drake']
  s.email = ['kyledrake@gmail.com']
  s.homepage = 'https://github.com/geoloqi/sinatra-geoloqi'
  s.summary = 'Geoloqi adapter for Sinatra'
  s.description = 'Geoloqi adapter for Sinatra, quickly allows you to make applications'

  s.files = Dir['{lib/sinatra,lib/rack,spec}/**/*'] + Dir['[A-Z]*']
  s.require_path = 'lib'

  s.rubyforge_project = s.name
  s.required_rubygems_version = '>= 1.3.4'
  s.add_dependency 'sinatra',   '>= 1.0'
  s.add_dependency 'geoloqi',   '>= 0.9.36'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rack-test', '= 0.6.1'
  s.add_development_dependency 'webmock',   '= 1.7.10'
  s.add_development_dependency 'minitest'
end
