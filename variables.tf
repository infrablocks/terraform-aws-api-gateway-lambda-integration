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
    method: string,
    integration_passthrough_behavior: optional(string)
    integration_request_templates: optional(map(string))
  }))
  default = [
    {
      path: "{proxy+}",
      method: "ANY"
    }
  ]
  nullable = false
}

variable "use_proxy_integration" {
  description = "Whether to use a proxy integration (`true`, \"AWS_PROXY\") or a custom integration (`false`, \"AWS\"). Defaults to `true`."
  type = bool
  default = true
  nullable = false
}

variable "tags" {
  default = {}
}
