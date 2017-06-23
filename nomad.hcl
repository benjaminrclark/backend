job "backend" {
  datacenters = ["dc1"]
  group "backend-group" {
    task "backend-task" {
      driver = "docker"
      config {
        image = "benjaminrclark/backend"
        volumes = ["local/backend.conf:/etc/backend.conf"]
        port_map {
	  http = 4567
        }
      }
      vault {
        policies      = ["nomad-services"]
        change_mode   = "restart"
      }
      template {
        data        = <<EOH
{ "hello": "{{ with secret "secret/nomad/services/backend" }}{{ .Data.value }}{{ end }}" }
EOH
        destination = "local/backend.conf"
      }
      service {
        name = "backend"
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
	  port "http" {
          }
        }
      }
    }
  }
}
