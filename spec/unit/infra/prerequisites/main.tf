module "api_gateway" {
  source  = "infrablocks/api-gateway/aws"
  version = "2.0.0-rc.2"

  region = var.region

  component = var.component
  deployment_identifier = var.deployment_identifier
}

module "lambda" {
  source  = "infrablocks/lambda/aws"
  version = "2.0.0-rc.5"

  region = var.region

  component             = var.component
  deployment_identifier = var.deployment_identifier

  lambda_function_name = "lambda-${var.deployment_identifier}"
  lambda_description   = "test lambda"

  lambda_zip_path = "${path.root}/lambda.zip"
  lambda_handler  = "handler.hello"
  lambda_runtime  = "nodejs16.x"
}
