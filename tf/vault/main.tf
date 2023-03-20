resource "vault_audit" "audit" {
  type     = var.audit_type
  options = var.audit_options
}

resource "vault_auth_backend" "backend" {
  type     = var.auth_type
}

resource "vault_generic_secret" "secret" {
  for_each = { for s in var.services : s.svc_name => s }

  path     = "secret/${var.name}/${each.value.svc_name}"

  data_json = jsonencode(each.value.data_json)
}

resource "vault_policy" "policy" {
  for_each = { for s in var.services : s.svc_name => s }

  name     = "${each.value.svc_name}-${var.name}"
  policy   = <<EOT

path "secret/data/${var.name}/${each.value.svc_name}" {
    capabilities = ${jsonencode(each.value.capabilities)}
}

EOT
}

resource "vault_generic_endpoint" "endpoint" {
  for_each = { for s in var.services : s.svc_name => s }
  
  depends_on           = [vault_auth_backend.backend]

  path                 = "auth/userpass/users/${each.value.svc_name}-${var.name}"
  ignore_absent_fields = true
  data_json            = jsonencode({
    policies = ["${each.value.svc_name}-${var.name}"],
    password = "${each.value.endpoint_password}"
  })
}