require 'sinatra'

set :bind, '0.0.0.0'

set :logging, true
 
get '/' do
  content_type 'application/json'
  File.read(ENV.fetch("CONFIG","/etc/backend.conf")) 
end
