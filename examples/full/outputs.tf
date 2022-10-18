output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "stage_execution_arn" {
  value = module.api_gateway_lambda_resource.stage_execution_arn
}

output "stage_invoke_url" {
  value = module.api_gateway_lambda_resource.stage_invoke_url
}

output "stage_name" {
  value = module.api_gateway_lambda_resource.stage_name
}

output "lambda_role_arn" {
  value = module.api_gateway_lambda_resource.lambda_role_arn
}
