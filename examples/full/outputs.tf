output "api_gateway_rest_api_id" {
  value = module.api_gateway.api_gateway_rest_api_id
}

output "api_gateway_rest_api_root_resource_id" {
  value = module.api_gateway.api_gateway_rest_api_root_resource_id
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "api_gateway_redeployment_triggers" {
  value = module.api_gateway_lambda_integration.api_gateway_redeployment_triggers
}
