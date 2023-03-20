variable "docker_containers" {
  type = list(object({
    name      = string
    image     = string
    networks  = string
    env       = list(string)
    ports     = list(object({
      internal = number
      external = number
    }))
  }))
}

variable "environment" {
  type = string
}