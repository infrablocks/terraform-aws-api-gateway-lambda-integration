variable "region" {
  description = "AWS region"
}

variable "component" {}
variable "deployment_identifier" {}

variable "lambda_function_name" {}

variable "api_gateway_rest_api_id" {
  description = "The ID of the API gateway REST API for which this deployment is being managed."
}
variable "api_gateway_rest_api_root_resource_id" {
  description = "The resource ID of the REST API's root"
}

variable "api_gateway_resource_definitions" {
  type = list(object({
    path: string,
    methods: list(string)
  }))
  default = [
    {
      path: "{proxy+}",
      methods: ["ANY"]
    }
  ]
  nullable = false
}

variable "tags" {
  default = {}
}
