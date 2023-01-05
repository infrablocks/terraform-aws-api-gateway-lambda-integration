locals {
  resource_definitions = toset(sort(distinct([
    for definition in var.api_gateway_resource_definitions:
      definition.path
    if definition.path != "/"
  ])))
}

resource "aws_api_gateway_resource" "resource" {
  for_each = local.resource_definitions

  rest_api_id = var.api_gateway_rest_api_id
  parent_id = var.api_gateway_rest_api_root_resource_id
  path_part = replace(each.key, "/^.*\\//", "")
}
