require 'sinatra'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT','4567')
set :logging, true
 
get '/' do
  content_type 'application/json'
  File.read(ENV.fetch("CONFIG",'/etc/app.conf')) 
end
