data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "proxy_lambda_execution_role_policy_content" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "proxy_lambda_execution_role" {
  description = "proxy_lambda_execution_role"
  tags = var.tags
  assume_role_policy = data.aws_iam_policy_document.proxy_lambda_execution_role_policy_content.json
}

data "aws_iam_policy_document" "proxy_lambda_execution_policy_content" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${var.region}:*:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:*"
    ]
  }
}

resource "aws_iam_role_policy" "proxy_lambda_execution_policy" {
  role = aws_iam_role.proxy_lambda_execution_role.id
  policy = data.aws_iam_policy_document.proxy_lambda_execution_policy_content.json
}

resource "aws_security_group" "sg_lambda" {
  description = "proxy-lambda-${var.deployment_identifier}"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.lambda_ingress_cidr_blocks
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.lambda_egress_cidr_blocks
  }
}

resource "aws_lambda_function" "lambda" {
  filename = var.lambda_zip_path
  function_name = var.lambda_function_name
  role = aws_iam_role.proxy_lambda_execution_role.arn
  handler = var.lambda_handler
  source_code_hash = base64sha256(filebase64(var.lambda_zip_path))
  runtime = local.lambda_runtime
  timeout = local.lambda_timeout
  memory_size = local.lambda_memory_size

  environment {
    variables = var.lambda_environment_variables
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.sg_lambda.id
    ]
    subnet_ids = var.lambda_subnet_ids
  }

  tags = local.tags
}

