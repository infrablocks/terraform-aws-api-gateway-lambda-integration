# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway deployment' do
  describe 'by default' do
    let(:api_gateway_id) do
      output(role: :prerequisites, name: 'api_gateway_id')
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates an API gateway deployment' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_deployment'))
    end

    it 'uses the provided API gateway ID for the API gateway deployment' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_deployment')
              .with_attribute_value(:rest_api_id, api_gateway_id))
    end

    it 'uses an empty string for the stage name for the ' \
       'API gateway deployment' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_api_gateway_deployment')
              .with_attribute_value(:stage_name, ''))
    end
  end
end
