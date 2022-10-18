# frozen_string_literal: true

require 'spec_helper'

describe 'lambda execution role' do
  describe 'by default' do
    let(:region) { var(role: :root, name: 'region') }
    let(:account_id) { var(role: :root, name: 'account_id') }

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a role' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .once)
    end

    it 'allows the lambda service to assume the role' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role')
              .with_attribute_value(
                :assume_role_policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: 'sts:AssumeRole',
                  Principal: {
                    Service: 'lambda.amazonaws.com'
                  }
                )
              ))
    end

    it 'creates a role policy' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .once)
    end

    it 'allows log group creation' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: 'logs:CreateLogGroup',
                  Resource: "arn:aws:logs:#{region}:*:*"
                )
              ))
    end

    it 'allows sending of log events' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: %w[logs:CreateLogStream logs:PutLogEvents],
                  Resource: "arn:aws:logs:#{region}:#{account_id}:*"
                )
              ))
    end

    it 'allows managing network interfaces' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_role_policy')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: %w[
                    ec2:DescribeNetworkInterfaces
                    ec2:CreateNetworkInterface
                    ec2:DeleteNetworkInterface
                    ec2:DescribeSecurityGroups
                    ec2:DescribeSubnets
                    ec2:DescribeVpcs
                  ],
                  Resource: '*'
                )
              ))
    end
  end
end
