require 'sinatra'
require 'json'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT','4567')
set :logging, true
 
get '/' do
  content_type 'application/json'
  config = JSON.parse(File.read(ENV.fetch("CONFIG","/etc/app.conf")))
  status config['status']
  File.read(ENV.fetch("CONFIG",'/etc/app.conf')) 
end
