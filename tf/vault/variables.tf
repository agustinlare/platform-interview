variable "name" {
  type = string
}

variable "audit_type" {
  type = string
  default = "file"
}

variable "audit_options" {
  type = map(any)
  default = {
    file_path = "/vault/logs/audit"
  }
}

variable "auth_type" {
  type = string
  default = "userpass"
}

variable "services" {
  type = list(object({
    svc_name         = string
    data_json        = map(any)
    capabilities     = list(string)
    ignore_absent_fields = bool
    endpoint_password = string
  }))
  default = [{
    svc_name         = ""
    data_json        = {}
    capabilities     = ["list", "read"]
    ignore_absent_fields = true
    endpoint_password = ""
  }]
}