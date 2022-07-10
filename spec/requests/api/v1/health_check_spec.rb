require 'swagger_helper'

RSpec.describe 'api/v1/health_check', type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/health_check' do
    get 'check server health' do
      tags 'Health Check'

      response 200, 'successful' do
        schema type: :string

        before do |example|
          unless example.metadata[:path_item][:template].starts_with? '/api/v1'
            example.metadata[:path_item][:template] = example.metadata[:path_item][:template].prepend('/api/v1')
          end
        end

        run_test!

        after do |example|
          example.metadata[:response][:content] = { 'application/text' => { example: response.body } }
          example.metadata[:path_item][:template].delete_prefix!('/api/v1')
        end
      end
    end
  end
end
