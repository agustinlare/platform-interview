locals {
  containers = {
    for container in var.docker_containers:
    container.name => {
      name      = "${container.name}-${var.environment}"
      image     = container.image
      networks  = container.networks
      env       = container.env
      ports     = container.ports
    }
  }
}

resource "docker_container" "containers" {
  for_each = local.containers

  name  = each.value.name
  image = each.value.image

  networks_advanced {
    name = each.value.networks
  }

  env = each.value.env

  dynamic "ports" {
    for_each = length(each.value.ports) > 0 ? [each.value.ports[0]] : []
    
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }  

  lifecycle {
    ignore_changes = all
  }
}