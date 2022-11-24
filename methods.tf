locals {
  method_definitions = merge([
    for definition in var.api_gateway_resource_definitions: {
      for method in definition.methods:
        "${definition.path}-${method}" => {
          path: definition.path,
          method: method
        }
    }
  ]...)
}

resource "aws_api_gateway_method" "method" {
  for_each = local.method_definitions

  rest_api_id = var.api_gateway_rest_api_id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id

  http_method = each.value.method
  authorization = "NONE"
}
