# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway methods' do
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

    it 'creates a method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method'))
    end

    it 'uses the provided API gateway ID for the method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id))
    end

    it 'uses an authorization of "NONE"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:authorization, 'NONE'))
    end

    it 'uses an HTTP method of ANY for the method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
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

    it 'creates a method for each provided method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .twice)
    end

    it 'uses the provided API gateway ID for the methods' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id)
              .twice)
    end

    it 'uses an authorization of "NONE" for the methods' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:authorization, 'NONE')
              .twice)
    end

    it 'uses the provided HTTP methods for the methods' do
      %w[OPTIONS GET].each do |http_method|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_api_gateway_method')
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

    it 'creates a method for each provided method' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .thrice)
    end

    it 'uses the provided API gateway ID for the methods' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id)
              .thrice)
    end

    it 'uses an authorization of "NONE" for the methods' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_method')
              .with_attribute_value(:authorization, 'NONE')
              .thrice)
    end

    it 'uses the provided HTTP methods for the methods' do
      %w[OPTIONS GET ANY].each do |http_method|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_api_gateway_method')
                .with_attribute_value(:http_method, http_method))
      end
    end
  end
end
