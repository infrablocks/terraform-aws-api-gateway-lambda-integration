# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  let(:rest_api_id) { output(role: :full, name: 'api_gateway_rest_api_id') }

  describe 'API gateway resources' do
    subject(:resources) do
      client = Aws::APIGateway::Client.new
      client.get_resources(rest_api_id: rest_api_id).items
    end

    let(:root_resource) { resources.find { |r| r.path = '/' } }
    let(:proxy_resource) { resources.find { |r| r.path = '/{proxy+}' } }

    it 'creates a {proxy+} resource' do
      expect(proxy_resource).not_to(be_nil)
    end

    it 'creates an ANY method on the {proxy+} resource' do
      expect(proxy_resource.resource_methods["ANY"]).not_to(be_nil)
    end

    it 'creates an ANY method on the root resource' do
      expect(root_resource.resource_methods["ANY"]).not_to(be_nil)
    end
  end
end
