variable "services" {
  type = list(object({
    svc_name             = string
    data_json            = map(any)
    capabilities         = list(string)
    ignore_absent_fields = bool
    endpoint_password    = string
  }))
  default = []
}

