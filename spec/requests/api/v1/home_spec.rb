require 'swagger_helper'

RSpec.describe 'api/v1', type: :request do
  path '/api/v1' do
    get 'check auth' do
      tags 'Auth Check'
      security [Bearer: []]

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/response_root_get'

        let!(:user) { create :user }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        include_context 'with swagger test'
      end

      response 401, 'unauthorized' do
        schema '$ref' => '#/components/schemas/response_root_get_401'

        let(:Authorization) { 'Bearer 12345667' }
        include_context 'with swagger test'
      end
    end
  end
end
