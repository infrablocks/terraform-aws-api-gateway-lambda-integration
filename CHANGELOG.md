## Unreleased

## 2.0.0 (December 28th, 2022)

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module's name has changed from 
  `infrablocks/api-gateway-lambda-resource/aws` to 
  `infrablocks/api-gateway-lambda-integration/aws`.
* This module is now compatible with Terraform 1.3 and higher.
* This module is now compatible with AWS provider 4.0 and higher.
* This module no longer manages the lambda directly, in favour of using
  the `infrablocks/lambda/aws` module for this purpose instead. As such, the
  `lambda_subnet_ids`, `lambda_zip_path`, `lambda_ingress_cidr_blocks`,
  `lambda_egress_cidr_blocks`, `lambda_environment_variables`,
  `lambda_memory_size`, `lambda_timeout`, `lambda_handler`, `lambda_runtime`
  and `vpc_id` variables are no longer supported.
* This module no longer manages the deployment, in favour of using the
  `deployment` submodule of the `infrablocks/api-gateway/aws` module. As such,
  the `api_gateway_stage_name` is no longer supported.
* The `api_gateway_id` variable has been renamed to `api_gateway_rest_api_id`.
* The `api_gateway_root_resource_id` variable has been renamed to
  `api_gateway_rest_api_root_resource_id`.
* The `account_id` variable has been removed with the account ID now being
  determined via a data resource.
* This module now allows multiple resources and methods to be configured each
  integrated to the specified lambda, configured via the 
  `api_gateway_resource_definitions` variable. As such, the 
  `resource_path_part`, and `resource_http_method` variables are no longer
  supported.

## 1.0.0 (May 27th, 2021)

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module is now compatible with Terraform 0.14 and higher.

## 0.1.4 (September 9th, 2017) 

IMPROVEMENTS:

* The zone ID and the DNS name of the ELB are now output from the module.   