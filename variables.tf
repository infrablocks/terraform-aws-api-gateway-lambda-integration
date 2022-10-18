variable "region" {
  description = "AWS region"
}

variable "component" {}
variable "deployment_identifier" {}

variable "account_id" {
  description = "AWS account id where the lambda execution"
}

variable "vpc_id" {
  description = "VPC to deploy the lambda to"
}

variable "lambda_subnet_ids" {
  description = "Subnet ids to deploy the lambda to"
  type = list(string)
}

variable "api_gateway_id" {}
variable "api_gateway_stage_name" {}
variable "api_gateway_root_resource_id" {}

variable "resource_path_part" {}

variable "lambda_zip_path" {}

variable "lambda_ingress_cidr_blocks" {
  type = list(string)
}
variable "lambda_egress_cidr_blocks" {
  type = list(string)
}

variable "lambda_environment_variables" {
  description = "Environment variables to be provided to the lambda function."
  type = map(string)
}

variable "resource_http_method" {
  description = "HTTP method on the API gateway to integrate with lambda function"
  default = "GET"
}

variable "lambda_function_name" {}
variable "lambda_handler" {}
variable "lambda_runtime" {
  default = "nodejs14.x"
}
variable "lambda_timeout" {
  default = 30
}
variable "lambda_memory_size" {
  default = 128
}

variable "tags" {
  default = {}
}

