terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Pull latest nginx image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Run container
resource "docker_container" "nginx" {
  name  = "nginx-server"
  image = docker_image.nginx.latest
  ports {
    internal = 80
    external = 8080
  }
}
