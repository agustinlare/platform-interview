module "vault_stg" {
  source = "./vault"

  providers = {
    vault = vault.vault_stg
  }

  name       = "staging"

  services = [
    {
      svc_name = "gateway"
      data_json = {
        db_user     = "gateway"
        db_password = "965d3c27-9e20-4d41-91c9-61e6631870e7"
      }
      capabilities         = ["list", "read"]
      ignore_absent_fields = true
      endpoint_password    = "123-gateway-staging"
    },
    {
      svc_name = "payment"
      data_json = {
        db_user     = "payment"
        db_password = "a63e8938-6d49-49ea-905d-e03a683059e7"
      }
      capabilities         = ["list", "read"]
      ignore_absent_fields = true
      endpoint_password    = "123-payment-staging"
    },
    {
      svc_name = "account"
      data_json = {
        db_user     = "account"
        db_password = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
      }
      capabilities         = ["list", "read"]
      ignore_absent_fields = true
      endpoint_password    = "123-account-staging"
    }
  ]
}

module "containers_stg" {
  source = "./docker_containers"

  environment = "staging"

  docker_containers = [ {
        name      = "account"
        image     = "form3tech-oss/platformtest-account"
        networks  = "vagrant_staging"
        env       = [
        "VAULT_ADDR=http://vault-staging:8200",
        "VAULT_USERNAME=account-staging",
        "VAULT_PASSWORD=123-account-staging",
        "ENVIRONMENT=staging"
        ]
        ports = []
    },
    {
        name      = "payment"
        image     = "form3tech-oss/platformtest-payment"
        networks  = "vagrant_staging"
        env       = [
        "VAULT_ADDR=http://vault-staging:8200",
        "VAULT_USERNAME=payment-staging",
        "VAULT_PASSWORD=123-payment-staging",
        "ENVIRONMENT=staging"
        ]
        ports = []
    },
    {
        name      = "gateway"
        image     = "form3tech-oss/platformtest-gateway"
        networks  = "vagrant_staging"
        env       = [
        "VAULT_ADDR=http://vault-staging:8200",
        "VAULT_USERNAME=gateway-staging",
        "VAULT_PASSWORD=123-gateway-staging",
        "ENVIRONMENT=staging"
        ]
        ports = []
    },
    {
        name      = "frontend"
        image     = "docker.io/nginx:latest"
        networks  = "vagrant_staging"
        env       = []
        ports     = [{
            internal = 80
            external = 4082
        }]
    }  ]

  depends_on = [
    module.vault_stg
  ]
}