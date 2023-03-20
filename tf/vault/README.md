# Terrafor Module for Provisioning Vault instance and Secrets

This Terraform module provisions secrets in Hashicorp Vault for a specified application or service. The module can be used to create a Vault instance and configure the audit and authentication backends, as well as create secrets, policies, and authentication endpoints for multiple services.

## Usage

```=hcl
module "vault_secrets" {
  source = "path/to/vault_secrets"

  name = "myapp"

  audit_type = "file"

  audit_options = {
    file_path = "/vault/logs/audit"
  }

  auth_type = "userpass"

  services = [
    {
      svc_name = "svc1"
      data_json = {
        username = "user1",
        password = "password1"
      }
      capabilities = ["read", "write"]
      endpoint_password = "endpointpassword1"
    },
    {
      svc_name = "svc2"
      data_json = {
        username = "user2",
        password = "password2"
      }
      capabilities = ["read"]
      endpoint_password = "endpointpassword2"
    }
  ]
}
```

## Variables

`name` (required): The name of the application or service for which secrets are being provisioned.

`audit_type` (optional, default: "file"): The type of audit backend to use for Vault.

`audit_options` (optional, default: {file_path = "/vault/logs/audit"}): The options to pass to the audit backend.

`auth_type` (optional, default: "userpass"): The type of authentication backend to use for Vault.

`services` (required): A list of objects representing the services or applications for which secrets will be managed by Vault.

`svc_name` (required): The name of the service.

`data_json` (required): A JSON object representing the secrets for the service.

`capabilities` (optional, default: ["list", "read"]): A list of capabilities that the service has for accessing its secrets.

`ignore_absent_fields` (optional, default: true): Whether to ignore absent fields in the data JSON object.

`endpoint_password` (optional): The password to use for the authentication endpoint for the service.

## Resources

`vault_audit`: Configures the audit backend for Vault.

`vault_auth_backend`: Configures the authentication backend for Vault.

`vault_generic_secret`: Manages secrets in Vault.

`vault_policy`: Defines policies for accessing secrets in Vault.

`vault_generic_endpoint`: Manages authentication endpoints for Vault.