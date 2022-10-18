# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'digest'

describe 'lambda' do
  describe 'by default' do
    let(:lambda_zip_file_path) do
      var(role: :root, name: 'lambda_zip_path')
    end

    let(:lambda_function_name) do
      var(role: :root, name: 'lambda_function_name')
    end

    let(:lambda_handler) do
      var(role: :root, name: 'lambda_handler')
    end

    let(:lambda_environment_variables) do
      var(role: :root, name: 'lambda_environment_variables')
    end

    let(:private_subnet_ids) do
      output(role: :prerequisites, name: 'private_subnet_ids')
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a lambda function' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .once)
    end

    it 'uses the provided lambda zip file path' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:filename, lambda_zip_file_path))
    end

    it 'derives the source code hash from the provided lambda zip file' do
      source_code =
        File.read(
          File.join(
            'spec', 'unit', 'infra', 'root', lambda_zip_file_path
          )
        )
      source_code_base64 = Base64.strict_encode64(source_code)
      source_code_sha256 =
        Digest::SHA2.new(256)
                    .base64digest(source_code_base64)

      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:source_code_hash, source_code_sha256))
    end

    it 'uses the provided lambda function name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:function_name, lambda_function_name))
    end

    it 'uses the provided lambda handler name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:handler, lambda_handler))
    end

    it 'uses a lambda runtime of nodejs14.x' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:runtime, 'nodejs14.x'))
    end

    it 'uses a lambda timeout of 30 seconds' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:timeout, 30))
    end

    it 'uses a lambda memory size of 128 MB' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:memory_size, 128))
    end

    it 'has no tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:tags, nil))
    end

    it 'uses the provided environment variables' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:environment, 0, :variables], lambda_environment_variables
              ))
    end

    it 'uses the provided VPC subnet IDs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(
                [:vpc_config, 0, :subnet_ids],
                containing_exactly(*private_subnet_ids)
              ))
    end
  end

  describe 'when lambda runtime provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_runtime = 'nodejs16.x'
      end
    end

    it 'uses the specified lambda runtime' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:runtime, 'nodejs16.x'))
    end
  end

  describe 'when lambda timeout provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_timeout = 60
      end
    end

    it 'uses the specified lambda timeout' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:timeout, 60))
    end
  end

  describe 'when lambda memory size provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.lambda_memory_size = 196
      end
    end

    it 'uses the specified lambda memory size' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:memory_size, 196))
    end
  end

  describe 'when tags provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.tags = {
          Role: 'website'
        }
      end
    end

    it 'uses the specified tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_lambda_function')
              .with_attribute_value(:tags, { Role: 'website' }))
    end
  end
end
