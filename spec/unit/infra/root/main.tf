data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "api_gateway_lambda_integration" {
  source = "../../../.."

  region = var.region

  component = var.component
  deployment_identifier = var.deployment_identifier

  api_gateway_rest_api_id = data.terraform_remote_state.prerequisites.outputs.api_gateway_rest_api_id
  api_gateway_rest_api_root_resource_id = data.terraform_remote_state.prerequisites.outputs.api_gateway_rest_api_root_resource_id

  api_gateway_resource_definitions = var.api_gateway_resource_definitions

  lambda_function_name = data.terraform_remote_state.prerequisites.outputs.lambda_function_name

  use_proxy_integration = var.use_proxy_integration

  tags = var.tags
}
