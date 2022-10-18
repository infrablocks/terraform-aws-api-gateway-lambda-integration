variable "region" {}
variable "component" {}
variable "deployment_identifier" {}

variable "account_id" {}

variable "resource_path_part" {}
variable "resource_http_method" {}

variable "lambda_zip_path" {}
variable "lambda_ingress_cidr_blocks" {
  type = list(string)
}
variable "lambda_egress_cidr_blocks" {
  type = list(string)
}
variable "lambda_environment_variables" {
  type = map(string)
}
variable "lambda_function_name" {}
variable "lambda_handler" {}
variable "lambda_runtime" {
  type = string
  default = null
}
variable "lambda_timeout" {
  type = number
  default = null
}
variable "lambda_memory_size" {
  type = number
  default = null
}

variable "api_gateway_stage_name" {}

variable "tags" {
  type = map(string)
  default = null
}