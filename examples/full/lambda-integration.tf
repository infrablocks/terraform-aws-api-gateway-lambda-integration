module "api_gateway_lambda_integration" {
  source = "../../"

  region = var.region

  component = var.component
  deployment_identifier = var.deployment_identifier

  api_gateway_rest_api_id = module.api_gateway.api_gateway_rest_api_id
  api_gateway_rest_api_root_resource_id = module.api_gateway.api_gateway_rest_api_root_resource_id

  lambda_function_name = module.lambda.lambda_function_name

  depends_on = [
    module.api_gateway,
    module.lambda
  ]
}
