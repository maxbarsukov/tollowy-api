require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/users' do
    get 'list users' do
      tags 'Users'
      produces 'application/json'

      PaginationGenerator.parameters(binding)

      response 200, 'successful' do
        schema Schemas::Response::Users::Index.ref
        PaginationGenerator.headers(binding)

        before { create_list(:user, 2, :with_user_role) }

        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }
        include_context 'with swagger test'
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response 200, 'user found' do
        schema Schemas::Response::Users::Show.ref

        let(:id) { create(:user, :with_user_role).id }
        include_context 'with swagger test'
      end

      response 404, 'user not found' do
        schema Schemas::Response::Users::Show404.ref

        let(:id) { -1 }
        include_context 'with swagger test'
      end
    end

    %w[patch put].each do |req|
      public_send req, 'Updates a user' do
        tags 'Users'
        description 'Updates a user'

        security [Bearer: []]

        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :string

        parameter name: :data, in: :body, schema: Schemas::Parameter::Users::Update.ref

        response 200, 'user data updated' do
          schema Schemas::Response::Users::Show.ref

          let!(:user) { create :user, :with_user_role }
          let(:id) { user.id }
          let(:Authorization) { ApiHelper.authenticated_header(user: user) }
          let(:data) do
            {
              data: {
                type: 'auth',
                attributes: {
                  username: 'NewGreatUsername1',
                  current_password: 'Password11',
                  password: 'NewPassword11'
                }
              }
            }
          end
          include_context 'with swagger test'
        end

        response 401, 'Unauthorized' do
          schema Schemas::YouMustBeLoggedIn.ref

          let!(:user) { create :user, :with_user_role }
          let(:Authorization) { 'Bearer 12345667' }
          let(:id) { user.id }
          let(:data) do
            {
              data: {
                type: 'auth',
                attributes: {
                  username: 'NewGreatUsername1'
                }
              }
            }
          end
          include_context 'with swagger test'
        end

        response 403, 'Not enough permissions' do
          schema Schemas::Response::Error.ref

          let!(:user) { create :user, :with_user_role }
          let(:Authorization) { ApiHelper.authenticated_header(user: user) }
          let(:id) { user.id }
          let(:data) do
            {
              data: {
                type: 'auth',
                attributes: {
                  role: 50
                }
              }
            }
          end
          include_context 'with swagger test'
        end

        response 404, 'user not found' do
          schema Schemas::Response::Users::Show404.ref

          let!(:user) { create :user, :with_user_role }
          let(:Authorization) { ApiHelper.authenticated_header(user: user) }
          let(:id) { -1 }
          let(:data) do
            {
              data: {
                type: 'auth',
                attributes: {
                  username: 'NewGreatUsername1'
                }
              }
            }
          end
          include_context 'with swagger test'
        end

        response 422, 'unprocessable entity' do
          schema Schemas::RecordIsInvalid.ref

          let!(:user) { create :user, :with_user_role }
          let(:Authorization) { ApiHelper.authenticated_header(user: user) }
          let(:id) { user.id }
          let(:data) do
            {
              data: {
                type: 'auth',
                attributes: {
                  username: 'инвалид'
                }
              }
            }
          end
          include_context 'with swagger test'
        end
      end
    end
  end
end
