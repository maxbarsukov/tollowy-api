require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/users' do
    get 'list users' do
      tags 'Users'
      produces 'application/json'

      security [Bearer: []]

      PaginationGenerator.parameters(binding)

      parameter name: 'sort',
                in: :query,
                description: 'Sort by',
                type: :string, enum: %w[username -username email -email created_at -created_at],
                example: 'username,-created_at',
                required: false

      parameter name: 'filter[username]', in: :query,
                description: 'Filter by username contains', example: 'username',
                type: :string, required: false

      parameter name: 'filter[email]', in: :query,
                description: 'Filter by email contains', example: '@gmail',
                type: :string, required: false

      parameter name: 'filter[created_at[before]]', in: :query,
                description: 'Filter by created before date', example: '2022-04-15',
                type: :string, required: false

      parameter name: 'filter[created_at[after]]', in: :query,
                description: 'Filter by created after date', example: '2022-04-15',
                type: :string, required: false

      response 200, 'successful' do
        schema Schemas::Response::Users::Index.ref
        PaginationGenerator.headers(binding)

        before { create_list(:user, 2, :with_user_role) }

        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }

        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'

      security [Bearer: []]

      parameter name: :id, in: :path, type: :string

      response 200, 'user found' do
        schema Schemas::Response::Users::Show.ref

        let(:id) { create(:user, :with_user_role).id }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end

      response 404, 'user not found' do
        schema Schemas::Response::Users::Show404.ref

        let(:id) { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
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

  path '/users/{id}/posts' do
    get 'list user posts' do
      tags 'Users'
      description 'Get posts'

      security [Bearer: []]

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      PaginationGenerator.parameters(binding)

      parameter name: 'sort',
                in: :query,
                description: 'Sort by',
                type: :string, enum: %w[body -body created_at -created_at],
                example: 'body,-created_at',
                required: false

      parameter name: 'filter[body]', in: :query,
                description: 'Filter by body contains',
                type: :string, required: false

      parameter name: 'filter[created_at[before]]', in: :query,
                description: 'Filter by created before date', example: '2023-04-15',
                type: :string, required: false

      parameter name: 'filter[created_at[after]]', in: :query,
                description: 'Filter by created after date', example: '2021-04-15',
                type: :string, required: false

      response 200, 'successful' do
        schema Schemas::Response::Posts::Index.ref
        PaginationGenerator.headers(binding)

        let!(:user) do
          create(:user, :with_user_role) do |user|
            user.posts = create_list(:post, 5)
          end
        end
        let(:id) { user.id }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }

        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:id) { user.id }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        let(:'page[number]') { -1 }
        include_context 'with swagger test'
      end
    end
  end
end
