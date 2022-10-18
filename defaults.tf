locals {
  # default for cases when `null` value provided, meaning "use default"
  lambda_runtime     = var.lambda_runtime == null ? "nodejs14.x" : var.lambda_runtime
  lambda_timeout     = var.lambda_timeout == null ? 30 : var.lambda_timeout
  lambda_memory_size = var.lambda_memory_size == null ? 128 : var.lambda_memory_size
  tags               = var.tags == null ? {} : var.tags
}