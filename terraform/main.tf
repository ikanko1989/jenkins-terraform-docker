terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Pull NGINX Docker image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Run NGINX container
resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.name  
  ports {
    internal = 80
    external = 8081
  }
}
