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
  end

  describe 'when resource definitions includes single path with multiple ' \
           'methods' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.api_gateway_resource_definitions = [
          {
            path: 'first',
            methods: %w[OPTIONS GET]
          }
        ]
      end
    end

    it 'creates an integration for each provided method' do
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

  describe 'when resource definitions includes multiple paths with multiple ' \
           'methods' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.api_gateway_resource_definitions = [
          {
            path: 'first',
            methods: %w[OPTIONS GET]
          },
          {
            path: 'second',
            methods: %w[ANY]
          }
        ]
      end
    end

    it 'creates an integration for each provided method and path' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .thrice)
    end

    it 'uses the provided API gateway REST API ID for each integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id)
              .thrice)
    end

    it 'uses a type of AWS_PROXY for each integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(:type, 'AWS_PROXY')
              .thrice)
    end

    it 'uses an integration HTTP method of POST for the integration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_integration')
              .with_attribute_value(
                :integration_http_method, 'POST'
              )
              .thrice)
    end

    it 'uses the provided HTTP methods for each integration' do
      %w[OPTIONS GET ANY].each do |http_method|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_api_gateway_integration')
                .with_attribute_value(:http_method, http_method))
      end
    end
  end
end
