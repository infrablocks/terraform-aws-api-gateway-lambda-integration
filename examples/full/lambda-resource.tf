data "aws_caller_identity" "caller" {}

module "api_gateway_lambda_resource" {
  source = "../../"

  region = var.region

  component = var.component
  deployment_identifier = var.deployment_identifier

  account_id = data.aws_caller_identity.caller.account_id
  vpc_id = module.base_network.vpc_id

  api_gateway_id = aws_api_gateway_rest_api.api.id
  api_gateway_root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  api_gateway_stage_name = "test"

  resource_http_method = "GET"
  resource_path_part = "resource"

  lambda_subnet_ids = module.base_network.private_subnet_ids
  lambda_zip_path = "${path.module}/lambda.zip"
  lambda_ingress_cidr_blocks = ["0.0.0.0/0"]
  lambda_egress_cidr_blocks = ["0.0.0.0/0"]
  lambda_function_name = "test-lambda-resource"
  lambda_handler = "handler.hello"
  lambda_environment_variables = {
    TEST_ENV_VARIABLE: "test-value"
  }

  tags = {
    Component: var.component,
    DeploymentIdentifier: var.deployment_identifier
  }
}
