# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway resources' do
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

    it 'creates a resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .once)
    end

    it 'uses the provided API gateway REST API ID for the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id))
    end

    it 'uses the provided REST API root resource ID as the parent ID for ' \
       'the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(
                :parent_id, api_gateway_rest_api_root_resource_id
              ))
    end

    it 'uses a path part of "{proxy+}" for the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(
                :path_part, '{proxy+}'
              ))
    end

    it 'outputs redeployment triggers' do
      expect(@plan)
        .to(include_output_creation(name: 'api_gateway_redeployment_triggers'))
    end
  end

  describe 'when multiple resource definitions provided' do
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
          },
          {
            path: '/second',
            method: 'ANY'
          }
        ]
      end
    end

    it 'creates a resource for each path' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .twice)
    end

    it 'uses the provided API gateway REST API ID for the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(:rest_api_id, api_gateway_rest_api_id)
              .twice)
    end

    it 'uses the provided REST API root resource ID as the parent ID for ' \
       'the resource' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_resource')
              .with_attribute_value(
                :parent_id, api_gateway_rest_api_root_resource_id
              )
              .twice)
    end

    it 'uses the provided paths as the path parts for the resource' do
      %w[first second].each do |path|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_api_gateway_resource')
                .with_attribute_value(:path_part, path))
      end
    end
  end
end
