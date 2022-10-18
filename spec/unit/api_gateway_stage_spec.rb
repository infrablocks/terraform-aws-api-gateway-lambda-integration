# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway stage' do
  describe 'by default' do
    let(:api_gateway_id) do
      output(role: :prerequisites, name: 'api_gateway_id')
    end
    let(:api_gateway_stage_name) do
      var(role: :root, name: 'api_gateway_stage_name')
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates an API gateway stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_stage'))
    end

    it 'uses the provided API gateway ID for the API gateway stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_stage')
              .with_attribute_value(:rest_api_id, api_gateway_id))
    end

    it 'uses the provided API gateway stage name for the API gateway stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_stage')
              .with_attribute_value(:stage_name, api_gateway_stage_name))
    end
  end
end
