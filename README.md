Terraform AWS API Gateway Lambda Integration
============================================

[![Version](https://img.shields.io/github/v/tag/infrablocks/terraform-aws-api-gateway-lambda-integration?label=version&sort=semver)](https://github.com/infrablocks/terraform-aws-api-gateway-lambda-integration/tags)
[![Build Pipeline](https://img.shields.io/circleci/build/github/infrablocks/terraform-aws-api-gateway-lambda-integration/main?label=build-pipeline)](https://app.circleci.com/pipelines/github/infrablocks/terraform-aws-api-gateway-lambda-integration?filter=all)
[![Maintainer](https://img.shields.io/badge/maintainer-go--atomic.io-red)](https://go-atomic.io)

A Terraform module for integrating a lambda to an existing API Gateway REST API
in AWS.

The API Gateway Lambda integration requires:

* An existing API Gateway REST API
* An existing Lambda function

The API Gateway Lambda integration consists of:

* resources
* methods
* integrations
* permissions

Usage
-----

To use the module, include something like the following in your Terraform
configuration:

```terraform
module "api_gateway_lambda_integration" {
  source  = "infrablocks/api-gateway-lambda-integration/aws"
  version = "2.0.0"

  region = "eu-west-2"

  component             = "lambda-resource"
  deployment_identifier = "production"

  api_gateway_rest_api_id               = "x3H41ka22w"
  api_gateway_rest_api_root_resource_id = "321pyrfif2"

  lambda_function_name = "lambda-function"
}
```

By default, the resource will allow any method at any path. However, stricter
path definitions can be provided using the `api_gateway_resource_definitions`
variable.

See the
[Terraform registry entry](https://registry.terraform.io/modules/infrablocks/api-gateway-lambda-resource/aws/latest)
for more details.

### Inputs

| Name                                    | Description                                                                                            |                  Default                  | Required |
|-----------------------------------------|--------------------------------------------------------------------------------------------------------|:-----------------------------------------:|:--------:|
| `region`                                | The region into which to deploy the API Gateway Lambda integration.                                    |                     -                     |   Yes    |
| `component`                             | The component for which the API Gateway Lambda integration is being managed.                           |                     -                     |   Yes    |
| `deployment_identifier`                 | An identifier for this instantiation.                                                                  |                     -                     |   Yes    |
| `lambda_function_name`                  | The name of the Lambda function to integrate from the API Gateway REST API.                            |                     -                     |   Yes    |
| `api_gateway_rest_api_id`               | The ID of the API Gateway REST API for which this Lambda integration is being managed.                 |                     -                     |   Yes    |
| `api_gateway_rest_api_root_resource_id` | The ID of the API Gateway REST API's root resource.                                                    |                     -                     |   Yes    |
| `api_gateway_resource_definitions`      | Definitions of the resources to manage on the API Gateway REST API for the Lambda.                     | `[ { path: "{proxy+}", method: "ANY" } ]` |    No    |
| `use_proxy_integration`                 | Whether to use a proxy integration (`true`, `"AWS_PROXY"`) or a custom integration (`false`, `"AWS"`). |                  `true`                   |    No    |
| `tags`                                  | A map of tags to add to created infrastructure components.                                             |                   `{}`                    |    No    |
| `timeout_milliseconds`                  | Custom timeout. The default value is 29,000 milliseconds.                                              |                     -                     |    No    |

### Outputs

| Name                                | Description                                                                 |
|-------------------------------------|-----------------------------------------------------------------------------|
| `api_gateway_redeployment_triggers` | A map of data which upon change should trigger a redeployment of the stage. |

### Compatibility

This module is compatible with Terraform versions greater than or equal to
Terraform 1.3 and the Terraform AWS provider 4.0.

Development
-----------

### Machine Requirements

In order for the build to run correctly, a few tools will need to be installed
on your development machine:

* Ruby (3.1)
* Bundler
* git
* git-crypt
* gnupg
* direnv
* aws-vault

#### Mac OS X Setup

Installing the required tools is best managed by [homebrew](http://brew.sh).

To install homebrew:

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, to install the required tools:

```shell
# ruby
brew install rbenv
brew install ruby-build
echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
eval "$(rbenv init -)"
rbenv install 3.1.1
rbenv rehash
rbenv local 3.1.1
gem install bundler

# git, git-crypt, gnupg
brew install git
brew install git-crypt
brew install gnupg

# aws-vault
brew cask install

# direnv
brew install direnv
echo "$(direnv hook bash)" >> ~/.bash_profile
echo "$(direnv hook zsh)" >> ~/.zshrc
eval "$(direnv hook $SHELL)"

direnv allow <repository-directory>
```

### Running the build

Running the build requires an AWS account and AWS credentials. You are free to
configure credentials however you like as long as an access key ID and secret
access key are available. These instructions utilise
[aws-vault](https://github.com/99designs/aws-vault) which makes credential
management easy and secure.

To run the full build, including unit and integration tests, execute:

```shell
aws-vault exec <profile> -- ./go
```

To run the unit tests, execute:

```shell
aws-vault exec <profile> -- ./go test:unit
```

To run the integration tests, execute:

```shell
aws-vault exec <profile> -- ./go test:integration
```

To provision the module prerequisites:

```shell
aws-vault exec <profile> -- ./go deployment:prerequisites:provision[<deployment_identifier>]
```

To provision the module contents:

```shell
aws-vault exec <profile> -- ./go deployment:root:provision[<deployment_identifier>]
```

To destroy the module contents:

```shell
aws-vault exec <profile> -- ./go deployment:root:destroy[<deployment_identifier>]
```

To destroy the module prerequisites:

```shell
aws-vault exec <profile> -- ./go deployment:prerequisites:destroy[<deployment_identifier>]
```

Configuration parameters can be overridden via environment variables. For
example, to run the unit tests with a seed of `"testing"`, execute:

```shell
SEED=testing aws-vault exec <profile> -- ./go test:unit
```

When a seed is provided via an environment variable, infrastructure will not be
destroyed at the end of test execution. This can be useful during development
to avoid lengthy provision and destroy cycles.

To subsequently destroy unit test infrastructure for a given seed:

```shell
FORCE_DESTROY=yes SEED=testing aws-vault exec <profile> -- ./go test:unit
```

### Common Tasks

#### Generating an SSH key pair

To generate an SSH key pair:

```shell
ssh-keygen -m PEM -t rsa -b 4096 -C integration-test@example.com -N '' -f config/secrets/keys/bastion/ssh
```

#### Generating a self-signed certificate

To generate a self signed certificate:

```shell
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

To decrypt the resulting key:

```shell
openssl rsa -in key.pem -out ssl.key
```

#### Managing CircleCI keys

To encrypt a GPG key for use by CircleCI:

```shell
openssl aes-256-cbc \
  -e \
  -md sha1 \
  -in ./config/secrets/ci/gpg.private \
  -out ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

To check decryption is working correctly:

```shell
openssl aes-256-cbc \
  -d \
  -md sha1 \
  -in ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

Contributing
------------

Bug reports and pull requests are welcome on GitHub at
https://github.com/infrablocks/terraform-aws-api-gateway-lambda-resource.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
-------

The library is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
