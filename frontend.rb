require 'diplomat'
require 'json'
require 'typhoeus'
require 'sinatra'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT','4567')
set :logging, true

  def call_backend_service
    backend = Diplomat::Service.get('backend', :first)
    puts "#{backend.Address} #{backend.Port}"
    if backend.Address.nil?
      puts "Service is DOWN"
      {:service => "DOWN"}
    else
      puts "Service is UP"
      backend_response = Typhoeus.get("http://#{backend.Address}:#{backend.ServicePort}/")
      puts backend_response
      response = {:service => "UP", :response_status => backend_response.response_code} 
      if backend_response.success? 
        message = JSON.parse(backend_response.response_body)
        response.merge(message)
      else
        response
      end
    end
  end

  get '/' do
    config = JSON.parse(File.read(ENV.fetch("CONFIG","/etc/app.conf")))
    erb :index, :locals => {
      :backend => call_backend_service,
      :frontend => config,
    }
  end
