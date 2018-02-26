require 'sinatra'
require 'json' 

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT','4567')
set :logging, true
 
def load_config
  JSON.parse(File.read(ENV.fetch("CONFIG","/etc/app.conf")))
end

config = load_config

Signal.trap("HUP") {
  config = load_config
}

get '/' do
  status config["status"]
  content_type 'text/plain'
  config["data"]
end
