job "test" {
  datacenters = ["dc1"]
  group "backend-group" {
    task "backend-task" {
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
      }
      config {
        image = "benjaminrclark/backend"
        network_mode = "host"
        volumes = ["local/app.conf:/etc/app.conf"]
      }
      vault {
        policies = ["nomad-services"]
        change_mode   = "restart"
      }
      template {
        data        = <<EOH
{ 
{{ with secret "secret/nomad/services/backend" }}
  "hello": "{{ .Data.value }}",
  "status": {{ .Data.status }}
{{ end }}
}
EOH
        destination = "local/app.conf"
        change_mode   = "restart"
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
    task "frontend-task" {
      driver = "docker"
      env {
        PORT = "${NOMAD_PORT_http}"
      }
      config {
        image = "benjaminrclark/frontend"
        network_mode = "host"
        volumes = ["local/app.conf:/etc/app.conf"]
      }
      vault {
        policies = ["nomad-services"]
        change_mode   = "restart"
      }
      template {
        data        = <<EOH
{
  "hello": "{{ with secret "secret/nomad/services/frontend" }}{{ .Data.value }}{{ end }}"
}
EOH
        destination = "local/app.conf"
        change_mode   = "restart"
      }
      service {
        name = "frontend"
        port = "http"
        check {
	  name = "alive"
	  type = "tcp"
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
