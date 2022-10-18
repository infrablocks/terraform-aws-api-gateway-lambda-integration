# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(role: :full)
  end

  def api_gateway_resources(api_id, path_part)
    client = Aws::APIGateway::Client.new
    client.get_resources(rest_api_id: api_id).items.select do |resource|
      resource.path_part = path_part
    end
  end

  def api_gateway_stages(api_id)
    client = Aws::APIGateway::Client.new
    client.get_stages(rest_api_id: api_id)
  end

  let(:rest_api_id) { output(role: :full, name: 'api_gateway_id') }

  describe 'API gateway resource' do
    subject { api_gateway_resources(rest_api_id, 'resource').first }

    its(:path_part) { is_expected.to(eq('resource')) }
  end

  describe 'lambda' do
    subject { lambda('test-lambda-resource') }

    it { is_expected.to(exist) }

    it { is_expected.to(have_env_vars(['TEST_ENV_VARIABLE'])) }

    its(:runtime) { is_expected.to(eq('nodejs14.x')) }
    its(:memory_size) { is_expected.to(eq(128)) }
    its(:timeout) { is_expected.to(eq(30)) }
    its(:handler) { is_expected.to(eq('handler.hello')) }
  end

  describe 'api gateway stage' do
    subject { api_gateway_stages(rest_api_id).item.first }

    its(:stage_name) { is_expected.to(eq('test')) }
  end
end
