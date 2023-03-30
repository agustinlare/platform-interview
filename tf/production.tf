module "vault_prod" {
  source = "./vault"

  providers = {
    vault = vault.vault_prod
  }

  name       = "production"

  services = [
    {
      svc_name = "gateway"
      data_json = {
        db_user     = "gateway"
        db_password = "965d3c27-9e20-4d41-91c9-61e6631870e7"
      }
      capabilities         = ["list", "read"]
      ignore_absent_fields = true
      endpoint_password    = "123-gateway-production"
    },
    {
      svc_name = "payment"
      data_json = {
        db_user     = "payment"
        db_password = "a63e8938-6d49-49ea-905d-e03a683059e7"
      }
      capabilities         = ["list", "read"]
      ignore_absent_fields = true
      endpoint_password    = "123-payment-production"
    },
    {
      svc_name = "account"
      data_json = {
        db_user     = "account"
        db_password = "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
      }
      capabilities         = ["list", "read"]
      ignore_absent_fields = true
      endpoint_password    = "123-account-production"
    }
  ]
}

module "containers_prod" {
  source = "./docker_containers"

  environment = "production"

  docker_containers = [ {
        name      = "account"
        image     = "form3tech-oss/platformtest-account"
        networks  = "vagrant_production"
        env       = [
        "VAULT_ADDR=http://vault-production:8200",
        "VAULT_USERNAME=account-production",
        "VAULT_PASSWORD=123-account-production",
        "ENVIRONMENT=production"
        ]
        ports = []
    },
    {
        name      = "payment"
        image     = "form3tech-oss/platformtest-payment"
        networks  = "vagrant_production"
        env       = [
        "VAULT_ADDR=http://vault-production:8200",
        "VAULT_USERNAME=payment-production",
        "VAULT_PASSWORD=123-payment-production",
        "ENVIRONMENT=production"
        ]
        ports = []
    },
    {
        name      = "gateway"
        image     = "form3tech-oss/platformtest-gateway"
        networks  = "vagrant_production"
        env       = [
        "VAULT_ADDR=http://vault-production:8200",
        "VAULT_USERNAME=gateway-production",
        "VAULT_PASSWORD=123-gateway-production",
        "ENVIRONMENT=production"
        ]
        ports = []
    },
    {
        name      = "frontend"
        image     = "docker.io/nginx:1.22.0-alpine"
        networks  = "vagrant_production"
        env       = []
        ports     = [{
            internal = 80
            external = 4081
        }]
    }  ]

  depends_on = [
    module.vault_prod
  ]
}