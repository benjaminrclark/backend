job "backend" {
  datacenters = ["dc1"]
  group "backend-group" {
    task "backend-task" {
      driver = "docker"
      config {
        image = "benjaminrclark/backend"
        port_map {
	  http = 4567
        }
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
