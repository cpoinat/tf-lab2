terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "image" {
  type = string
  default = "nginx:latest"
}

variable "container_memory_mb" {
  type = number
  default = 500
}

variable "container_count" {
  type = number
  default = 1
}

variable "starting_port" {
  type = number
  default = 3000
}

# Pulls the image
resource "docker_image" "nginx" {
  name = var.image
}

# Create a container
resource "docker_container" "web" {
  count = var.container_count
  image = docker_image.nginx.image_id
  name  = "web-${count.index}"
  
  ports {
    internal = "80"
    external = var.starting_port + count.index
  }
}
