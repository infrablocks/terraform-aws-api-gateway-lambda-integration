locals {
  resource_definitions = {
    for definition in var.api_gateway_resource_definitions:
      definition.path => definition
  }
}

resource "aws_api_gateway_resource" "resource" {
  for_each = local.resource_definitions

  rest_api_id = var.api_gateway_rest_api_id
  parent_id = var.api_gateway_rest_api_root_resource_id
  path_part = each.key
}
