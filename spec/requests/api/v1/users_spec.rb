require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    get 'list users' do
      tags 'Users'
      produces 'application/json'

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/response_users_get'

        before { create_list(:user, 2, :with_user_role) }

        include_context 'with swagger test'
      end
    end
  end

  path '/api/v1/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response 200, 'user found' do
        schema '$ref' => '#/components/schemas/response_users_id_get'

        let(:id) { create(:user, :with_user_role).id }
        include_context 'with swagger test'
      end

      response '404', 'user not found' do
        schema '$ref' => '#/components/schemas/response_users_id_get_404'

        let(:id) { -1 }
        run_test!
      end
    end
  end
end
