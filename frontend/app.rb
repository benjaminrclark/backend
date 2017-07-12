require 'diplomat'
require 'json'
require 'typhoeus'
require 'sinatra'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT','4567')
set :logging, true

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
      puts "Service is absent"
      {:service => "ABSENT"}
    else
      health = check_service(backend)
      puts "Service is #{health}"
      if health == "UP"
        backend_response = Typhoeus.get("http://#{backend.Service['Address']}:#{backend.Service['Port']}/")
        puts backend_response
        response = {:service => "UP", :response_status => backend_response.response_code} 
        if backend_response.success? 
          message = JSON.parse(backend_response.response_body)
          response.merge(message)
        else
          response
        end
      else
        response = {:service => health} 
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
