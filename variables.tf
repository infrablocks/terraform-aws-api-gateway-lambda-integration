variable "region" {
  description = "The region into which to deploy the API Gateway Lambda integration."
}

variable "component" {
  description = "The component for which the API Gateway Lambda integration is being managed."
}
variable "deployment_identifier" {
  description = "An identifier for this instantiation."
}

variable "lambda_function_name" {
  description = "The name of the Lambda function to integrate from the API Gateway REST API."
}

variable "api_gateway_rest_api_id" {
  description = "The ID of the API gateway REST API for which this Lambda integration is being managed."
}
variable "api_gateway_rest_api_root_resource_id" {
  description = "The ID of the API Gateway REST API's root resource."
}

variable "api_gateway_resource_definitions" {
  description = "Definitions of the resources to manage on the API Gateway REST API for the Lambda."
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
  description = "A map of tags to add to created infrastructure components."
  default = {}
}
