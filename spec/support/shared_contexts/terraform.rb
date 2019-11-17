require 'aws-sdk'
require 'awspec'
require 'ostruct'

require_relative '../terraform_module'

shared_context :terraform do
  include Awspec::Helper::Finder

  let(:vars) {
    OpenStruct.new(
        TerraformModule.configuration
            .for(:harness)
            .vars)
  }

  let(:api_gateway_client) { Aws::ApiGatewayV2::Client.new }
  let(:api_gateway_apis) { Aws::ApiGatewayV2::Client.new.get_apis }

  def api_gateway_api_ids()
    client = Aws::APIGateway::Client.new
    client.get_rest_apis["items"].collect do |api|
      api[:id]
    end
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

  def api_gateway_integration(api_id, resource_id, http_method)
    client = Aws::APIGateway::Client.new
    client.get_integration({
        rest_api_id: api_id,
        resource_id: resource_id,
        http_method: http_method
    })
  end

  def configuration
    TerraformModule.configuration
  end

  def output_for(role, name)
    TerraformModule.output_for(role, name)
  end

  def reprovision(overrides = nil)
    TerraformModule.provision_for(
        :harness,
        TerraformModule.configuration.for(:harness, overrides).vars)
  end
end