# Containers_dev Module

This module is used to create and manage Docker containers for a development environment. It uses the "docker_containers" sub-module to define the containers that will be created, along with their image, network, environment variables, and ports.

## Requirements

This module has the following requirements:

- Terraform version 0.12 or higher
- Docker installed on the host machine

## Usage

To use this module, include it in your Terraform code and set the required variables. Here is an example of how to use this module:

```=hcl
module "containers_dev" {
  source = "./docker_containers"

  environment = "development"

  docker_containers = [ {
        name      = "myapp"
        image     = "myapp:tag"
        networks  = "mynetwork"
        env       = [
          "KEY=VALUE"
        ]
        ports = [{
            internal = 80
            external = 8080
        }]
    } ]
}
```

## Variables

`environment` (required): The name of the environment to deploy the containers in.

`docker_containers` (required): A list of objects that define the Docker containers to be deployed. Each object contains the following attributes:
    `name` (required): The name of the container.
    `image` (required): The name of the Docker image to use for the container.
    `networks` (required): The name of the Docker network to attach the container to.
    `env` (optional): A list of environment variables to pass to the container. Each element in the list should be a string in the format of KEY=VALUE.
    `ports` (optional): A list of objects that define the port mapping for the container. Each object should contain the following attributes:
        `internal` (required): The internal port number of the container.
        `external` (required): The external port number to map to.

## Resources

`Docker containers`: The specified Docker containers will be created and started in the designated Docker network.