locals {
  method_definitions = {
    for definition in var.api_gateway_resource_definitions :
      "${definition.path}-${definition.method}" => definition
  }
}

resource "aws_api_gateway_method" "method" {
  for_each = local.method_definitions

  rest_api_id = var.api_gateway_rest_api_id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id

  http_method = each.value.method
  authorization = "NONE"
}
