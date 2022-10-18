# frozen_string_literal: true

require 'spec_helper'

describe 'API Gateway lambda resource' do
  describe 'by default' do
    let(:api_gateway_id) do
      output(role: :prerequisites, name: 'api_gateway_id')
    end

    let(:api_gateway_root_resource_id) do
      output(role: :prerequisites, name: 'api_gateway_root_resource_id')
    end

    let(:api_gateway_resource_path_part) do
      var(role: :root, name: 'resource_path_part')
    end

    let(:api_gateway_resource_http_method) do
      var(role: :root, name: 'resource_http_method')
    end

    let(:lambda_function_name) do
      var(role: :root, name: 'lambda_function_name')
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .once)
    end

    it 'uses the provided API gateway ID for the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(:rest_api_id, api_gateway_id))
    end

    it 'uses the provided root resource ID as the parent ID for the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(
                :parent_id, api_gateway_root_resource_id
              ))
    end

    it 'uses the provided resource path part as the path part ' \
       'for the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(
                :path_part, api_gateway_resource_path_part
              ))
    end

    it 'creates a method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method'))
    end

    it 'uses the provided API gateway ID for the method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:rest_api_id, api_gateway_id))
    end

    it 'uses an HTTP method of POST for the method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:http_method, 'POST'))
    end

    it 'uses an authorization of NONE for the method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:authorization, 'NONE'))
    end

    it 'adds a request model for application/json of Error' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(
                [:request_models], { 'application/json': 'Error' }
              ))
    end

    it 'creates an integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration'))
    end

    it 'uses the provided API gateway ID for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:rest_api_id, api_gateway_id))
    end

    it 'uses an HTTP method of POST for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:http_method, 'POST'))
    end

    it 'uses the provided integration HTTP method for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :integration_http_method, api_gateway_resource_http_method
              ))
    end

    it 'uses a type of AWS_PROXY for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS_PROXY'))
    end

    it 'allows API gateway to invoke the lambda' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_permission')
              .with_attribute_value(:action, 'lambda:InvokeFunction')
              .with_attribute_value(:principal, 'apigateway.amazonaws.com')
              .with_attribute_value(:function_name, lambda_function_name))
    end
  end
end
