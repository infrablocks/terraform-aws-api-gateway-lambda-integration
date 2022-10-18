# frozen_string_literal: true

require 'spec_helper'

describe 'lambda security group' do
  describe 'by default' do
    let(:vpc_id) do
      output(role: :prerequisites, name: 'vpc_id')
    end

    let(:lambda_ingress_cidr_blocks) do
      var(role: :root, name: 'lambda_ingress_cidr_blocks')
    end

    let(:lambda_egress_cidr_blocks) do
      var(role: :root, name: 'lambda_egress_cidr_blocks')
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a security group for the lambda' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'uses the provided VPC ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:vpc_id, vpc_id))
    end

    it 'allows ingress on any port with any protocol' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value([:ingress, 0, :from_port], 0)
              .with_attribute_value([:ingress, 0, :to_port], 0)
              .with_attribute_value([:ingress, 0, :protocol], '-1'))
    end

    it 'uses the provided ingress CIDR blocks' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:ingress, 0, :cidr_blocks], lambda_ingress_cidr_blocks
              ))
    end

    it 'allows egress on any port with any protocol' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value([:egress, 0, :from_port], 0)
              .with_attribute_value([:egress, 0, :to_port], 0)
              .with_attribute_value([:egress, 0, :protocol], '-1'))
    end

    it 'uses the provided egress CIDR blocks' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:egress, 0, :cidr_blocks], lambda_egress_cidr_blocks
              ))
    end
  end
end
