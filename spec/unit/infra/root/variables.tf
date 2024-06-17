variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "api_gateway_resource_definitions" {
  type = list(object({
    path : string,
    method : string,
    integration_passthrough_behavior : optional(string)
    integration_request_templates : optional(map(string))
  }))
  default = null
}

variable "use_proxy_integration" {
  type    = bool
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "timeout_milliseconds" {
  type    = number
  default = null
}
