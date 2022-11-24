variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "api_gateway_resource_definitions" {
  type = list(object({
    path: string,
    methods: list(string)
  }))
  default = null
}

variable "tags" {
  type = map(string)
  default = null
}
