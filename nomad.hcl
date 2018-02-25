job "test" {
  datacenters = ["dc1"]
  group "backend-group" {
    task "backend-task" {
      count = 1
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
      }
      config {
        image = "benjaminrclark/backend:0.1"
        volumes = ["secrets/app.conf:/etc/app.conf"]
      }
      vault {
        policies = ["nomad-services"]
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data        = <<EOH
{ 
{{ with secret "secret/nomad/services/test/backend" }}
  "data":"{{ .Data.value }}",
  "status":{{ .Data.status }}
{{ end }}
}
EOH
        destination = "secrets/app.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      service {
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
    task "frontend-task" {
      count = 1
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
        CONSUL_ADDR = "http://consul.service.consul:8500"
      }
      config {
        image = "benjaminrclark/frontend:0.1"
        volumes = ["secrets/app.conf:/etc/app.conf"]
      }
      vault {
        policies = ["nomad-services"]
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data        = <<EOH
{
{{ with secret "secret/nomad/services/frontend" }}
  "data":"{{ .Data.value }}",
  "status":{{ .Data.status }}
{{ end }}
}
EOH
        destination = "secrets/app.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      service {
        tags = ["traefik.frontend.rule=Host:comma-test.virt.ch.bbc.co.uk"]
        port = "http"
        check {
	  type = "http"
          path = "/"
	  interval = "10s"
	  timeout = "2s"
        }
      }
      update {
        canary = 1
        max_parallel = 1
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
