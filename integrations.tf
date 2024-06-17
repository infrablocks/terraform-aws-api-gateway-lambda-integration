locals {
  integration_definitions = {
    for definition in var.api_gateway_resource_definitions:
        "${definition.path}-${definition.method}" => definition
  }
}

data "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
}

resource "aws_api_gateway_integration" "integration" {
  for_each = local.integration_definitions

  rest_api_id = var.api_gateway_rest_api_id
  resource_id = each.value.path == "/" ? var.api_gateway_rest_api_root_resource_id : aws_api_gateway_resource.resource[each.value.path].id
  http_method = aws_api_gateway_method.method[each.key].http_method

  integration_http_method = "POST"

  type = var.use_proxy_integration ? "AWS_PROXY" : "AWS"

  passthrough_behavior = try(each.value.integration_passthrough_behavior, null)
  request_templates = try(each.value.integration_request_templates, null)

  uri = data.aws_lambda_function.lambda.invoke_arn

  timeout_milliseconds = var.timeout_milliseconds
}
