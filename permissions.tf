data "aws_caller_identity" "caller" {}

resource "aws_lambda_permission" "permission" {
  statement_id = "AllowExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.caller.account_id}:${var.api_gateway_rest_api_id}/*"
}
