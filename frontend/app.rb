require 'diplomat'
require 'json'
require 'typhoeus'
require 'sinatra'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT','4567')
set :logging, true

Diplomat.configure do |config|
  config.url = ENV.fetch("CONSUL_ADDR", "http://127.0.0.1:8500")
end

def load_config
  JSON.parse(File.read(ENV.fetch("CONFIG","/etc/app.conf")))
end

config = load_config

Signal.trap("HUP") {
  config = load_config
}

  def check_service(service)
    service.Checks.each do | check |
      if check['Status'] != "passing"
        return check['Status']
      end
    end
    return "UP"
  end

  def call_backend_service
    backend = Diplomat::Health.service('backend').sample
    if backend.nil?
      return "UNKNOWN", ""
    else
      health = check_service(backend)
      if health == "UP"
        puts "Backend UP #{backend.Service['Address']}:#{backend.Service['Port']}"
        backend_response = Typhoeus.get("http://#{backend.Service['Address']}:#{backend.Service['Port']}/")
        if backend_response.success?
          return "UP", backend_response.response_body
        else
          return "DOWN", ""
        end
      else
        return "DOWN", ""
      end
    end
  end

  get '/api' do
    content_type :json
    status config["status"]
    backend_status, backend_data = call_backend_service
    {
      :backend_status => backend_status,
      :backend_data => backend_data,
      :frontend_version => 2.0,
      :frontend_data => config["data"],
    }.to_json
  end

  get '/' do
    erb :index
  end
