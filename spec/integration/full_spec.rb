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

  def api_gateway_resources(api_id, path_part)
    client = Aws::APIGateway::Client.new
    client.get_resources(rest_api_id: api_id).items.select do |resource|
      resource.path_part = path_part
    end
  end

  let(:rest_api_id) { output(role: :full, name: 'api_gateway_rest_api_id') }

  describe 'API gateway resource' do
    subject { api_gateway_resources(rest_api_id, '{proxy+}').first }

    its(:path_part) { is_expected.to(eq('{proxy+}')) }
  end
end
