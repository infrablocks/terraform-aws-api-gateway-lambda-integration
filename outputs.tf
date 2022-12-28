locals {
  redeployment_triggers = merge(
    {
      for path in local.resource_definitions:
        "resource-${path}" => sha256(jsonencode(aws_api_gateway_resource.resource[path]))
    },
    {
      for key, definition in local.method_definitions:
        "method-${key}" => sha256(jsonencode(aws_api_gateway_method.method[key]))
    },
    {
      for key, definition in local.integration_definitions:
        "integration-${key}" => sha256(jsonencode(aws_api_gateway_integration.integration[key]))
    }
  )
}

output "api_gateway_redeployment_triggers" {
  description = "A map of data which upon change should trigger a redeployment of the stage."
  value = local.redeployment_triggers
}
