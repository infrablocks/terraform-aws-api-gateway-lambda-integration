# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway integrations' do
  let(:api_gateway_rest_api_id) do
    output(role: :prerequisites, name: 'api_gateway_rest_api_id')
  end

  let(:api_gateway_rest_api_root_resource_id) do
    output(role: :prerequisites, name: 'api_gateway_rest_api_root_resource_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates an integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration'))
    end

    it 'uses the provided API gateway REST API ID for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id))
    end

    it 'uses a type of AWS_PROXY for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS_PROXY'))
    end

    it 'uses an integration HTTP method of POST for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :integration_http_method, 'POST'
              ))
    end

    it 'uses an HTTP method of ANY for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:http_method, 'ANY'))
    end

    it 'does not set any passthrough behaviour on the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:passthrough_behaviour, a_nil_value))
    end

    it 'does not set any request templates on the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:request_templates, a_nil_value))
    end
  end

  describe 'when multiple resource definitions provided for the same path' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.api_gateway_resource_definitions = [
          {
            path: '/first',
            method: 'OPTIONS'
          },
          {
            path: '/first',
            method: 'GET'
          }
        ]
      end
    end

    it 'creates an integration for each provided definition' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .twice)
    end

    it 'uses the provided API gateway REST API ID for each integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id)
              .twice)
    end

    it 'uses a type of AWS_PROXY for each integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS_PROXY')
              .twice)
    end

    it 'uses an integration HTTP method of POST for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :integration_http_method, 'POST'
              )
              .twice)
    end

    it 'uses the provided HTTP methods for each integration' do
      %w[OPTIONS GET].each do |http_method|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_api_gateway_integration')
                .with_attribute_value(:http_method, http_method))
      end
    end
  end

  describe 'when multiple resource definitions provided for different paths' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.api_gateway_resource_definitions = [
          {
            path: '/first',
            method: 'OPTIONS'
          },
          {
            path: '/second',
            method: 'ANY'
          }
        ]
      end
    end

    it 'creates an integration for each provided definition' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .twice)
    end

    it 'uses the provided API gateway REST API ID for each integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id)
              .twice)
    end

    it 'uses a type of AWS_PROXY for each integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS_PROXY')
              .twice)
    end

    it 'uses an integration HTTP method of POST for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :integration_http_method, 'POST'
              )
              .twice)
    end

    it 'uses the provided HTTP methods for each integration' do
      %w[OPTIONS ANY].each do |http_method|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_api_gateway_integration')
                .with_attribute_value(:http_method, http_method))
      end
    end
  end

  describe 'when use_proxy_integration is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.use_proxy_integration = true
      end
    end

    it 'uses a type of AWS_PROXY for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS_PROXY'))
    end
  end

  describe 'when use_proxy_integration is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.use_proxy_integration = false
      end
    end

    it 'uses a type of AWS for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS'))
    end
  end

  describe 'when a resource definition includes passthrough_behaviour' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.use_proxy_integration = false
        vars.api_gateway_resource_definitions = [
          {
            path: 'first',
            method: 'OPTIONS',
            integration_passthrough_behavior: 'NEVER'
          }
        ]
      end
    end

    it 'sets the passthrough behaviour on the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :passthrough_behavior, 'NEVER'
              ))
    end
  end

  describe 'when a resource definition includes request_templates' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.use_proxy_integration = false
        vars.api_gateway_resource_definitions = [
          {
            path: '/first',
            method: 'OPTIONS',
            integration_request_templates: {
              'application/json': '{ "body": $input.json("$") }'
            }
          }
        ]
      end
    end

    it 'sets the request templates on the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :request_templates,
                {
                  'application/json': '{ "body": $input.json("$") }'
                }
              ))
    end
  end

  describe 'when timeout_milliseconds is provided' do
    timeout_milliseconds = 25_000

    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.use_proxy_integration = false
        vars.timeout_milliseconds = timeout_milliseconds
      end
    end

    it 'uses the provided timeout' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :timeout_milliseconds,
                timeout_milliseconds
              ))
    end
  end
end
