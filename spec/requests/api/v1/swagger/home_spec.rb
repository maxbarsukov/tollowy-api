require 'swagger_helper'

RSpec.describe 'api/v1', type: :request do
  path '/' do
    get 'check auth' do
      tags 'Auth Check'
      security [Bearer: []]

      response 200, 'successful' do
        schema Schemas::Response::Root::Index.ref

        let!(:user) { create :user }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 401, 'unauthorized' do
        schema Schemas::Response::Root::Index401.ref

        let(:Authorization) { 'Bearer 12345667' }
        include_context 'with swagger test'
      end
    end
  end
end
