locals {
  redeployment_triggers = merge(
    {
      for path, definition in local.resource_definitions:
        "resource-${path}" => aws_api_gateway_resource.resource[path].id
    },
    {
      for key, definition in local.method_definitions:
        "method-${key}" => aws_api_gateway_method.method[key].id
    },
    {
      for key, definition in local.integration_definitions:
        "integration-${key}" => aws_api_gateway_integration.integration[key].id
    }
  )
}

output "api_gateway_redeployment_triggers" {
  value = local.redeployment_triggers
}
