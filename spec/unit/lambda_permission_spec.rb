# frozen_string_literal: true

require 'spec_helper'

describe 'lambda execution role' do
  let(:api_gateway_rest_api_id) do
    output(role: :prerequisites, name: 'api_gateway_rest_api_id')
  end
  let(:lambda_function_name) do
    output(role: :prerequisites, name: 'lambda_function_name')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a lambda permission' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_permission')
              .once)
    end

    it 'allows API gateway to invoke the lambda' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_permission')
              .with_attribute_value(:action, 'lambda:InvokeFunction')
              .with_attribute_value(:principal, 'apigateway.amazonaws.com')
              .with_attribute_value(:function_name, lambda_function_name))
    end

    it 'allows API gateway to invoke the lambda for any stage, method, ' \
       'and path' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_permission')
              .with_attribute_value(
                :source_arn,
                matching(
                  %r{arn:aws:execute-api:.*:#{api_gateway_rest_api_id}/\*}
                )
              ))
    end
  end
end
