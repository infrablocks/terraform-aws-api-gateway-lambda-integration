locals {
  integration_definitions = merge([
    for definition in var.api_gateway_resource_definitions: {
      for method in definition.methods:
        "${definition.path}-${method}" => {
          path: definition.path,
          method: method
        }
    }
  ]...)
}

data "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
}

resource "aws_api_gateway_integration" "integration" {
  for_each = local.integration_definitions

  rest_api_id = var.api_gateway_rest_api_id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id
  http_method = aws_api_gateway_method.method[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = data.aws_lambda_function.lambda.invoke_arn
}
