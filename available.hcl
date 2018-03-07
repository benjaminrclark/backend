job "test" {
  datacenters = ["dc1"]
  group "backend-group" {
    task "backend-task" {
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
        CONFIG = "/local/app.conf"
      }
      config {
        image = "benjaminrclark/backend:0.2"
        command = "/usr/bin/ruby"
        args = ["/var/opt/sinatra/src/app.rb", "-o", "0.0.0.0"]
      }
      template {
        data        = <<EOH
{ 
  "data":"{{ key "nomad/services/test/backend/data" }}",
  "status":{{ key "nomad/services/test/backend/status" }}
}
EOH
        destination = "local/app.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      service {
        name = "backend"
        port = "http"
        check {
	  type = "http"
          path = "/"
	  interval = "10s"
	  timeout = "2s"
        }
      }
      resources {
        cpu = 500 # 500 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
	  port "http" {}
        }
      }
    }
  }
  group "frontend-group" {
    count = 1
    task "frontend-task" {
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
        CONFIG = "/local/app.conf"
        CONSUL_ADDR = "http://consul.service.consul:8500"
      }
      config {
        image = "benjaminrclark/frontend:0.1"
        command = "/usr/bin/ruby"
        args = ["/var/opt/sinatra/src/app.rb", "-o", "0.0.0.0"]
      }
      template {
        data        = <<EOH
{
  "data":"{{ key "nomad/services/test/frontend/data" }}",
  "status":{{ key "nomad/services/test/frontend/status" }}
}
EOH
        destination = "local/app.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      service {
        name = "frontend"
        tags = ["traefik.frontend.rule=Host:comma-test.virt.ch.bbc.co.uk"]
        port = "http"
        check {
	  type = "http"
          path = "/api"
	  interval = "10s"
	  timeout = "2s"
        }
      }
      resources {
        cpu = 500 # 500 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
	  port "http" {}
        }
      }
    }
  }
  group "frontend-group-2" {
    count = 1
    task "frontend-task" {
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
        CONFIG = "/local/app.conf"
        CONSUL_ADDR = "http://consul.service.consul:8500"
      }
      config {
        image = "benjaminrclark/frontend:0.1"
        command = "/usr/bin/ruby"
        args = ["/var/opt/sinatra/src/app.rb", "-o", "0.0.0.0"]
      }
      template {
        data        = <<EOH
{
  "data":"{{ key "nomad/services/test/frontend2/data" }}",
  "status":{{ key "nomad/services/test/frontend2/status" }}
}
EOH
        destination = "local/app.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      service {
        name = "frontend"
        tags = ["traefik.frontend.rule=Host:comma-test.virt.ch.bbc.co.uk"]
        port = "http"
        check {
	  type = "http"
          path = "/api"
	  interval = "10s"
	  timeout = "2s"
        }
      }
      resources {
        cpu = 500 # 500 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
	  port "http" {}
        }
      }
    }
  }
}

