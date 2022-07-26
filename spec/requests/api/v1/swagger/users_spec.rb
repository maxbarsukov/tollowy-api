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
                type: :string, enum: %w[username -username email -email created_at -created_at
                                        follow_count -follow_count followers_count -followers_count],
                example: '-created_at',
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
          let(:Authorization) { ApiHelper.authenticated_header(user:) }
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
          let(:Authorization) { ApiHelper.authenticated_header(user:) }
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
          let(:Authorization) { ApiHelper.authenticated_header(user:) }
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
          let(:Authorization) { ApiHelper.authenticated_header(user:) }
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
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:id) { user.id }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:'page[number]') { -1 }
        include_context 'with swagger test'
      end

      response 404, 'user not found' do
        schema Schemas::Response::Users::Show404.ref

        let(:id) { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end
  end

  path '/users/{id}/comments' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'get user comments' do
      tags 'Users'
      description 'Get user comments'

      security [Bearer: []]

      produces 'application/json'

      PaginationGenerator.parameters(binding)

      response 200, 'successful' do
        schema Schemas::Response::Posts::Comment.ref
        PaginationGenerator.headers(binding)

        let!(:post) { create(:post) }
        let!(:user) { post.user }
        before do
          5.times do |num|
            Comment.create!(
              commentable_id: post.id,
              commentable_type: 'Post',
              body: "comment#{num}",
              user_id: user.id
            )
          end
        end

        let(:id) { user.id }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:id) { create(:user).id }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        let(:'page[number]') { -1 }
        include_context 'with swagger test'
      end

      response 404, 'post not found' do
        schema Schemas::Response::Error.ref

        let(:id) { -1 }
        let(:Authorization) { 'token' }
        include_context 'with swagger test'
      end
    end
  end

  path '/users/{id}/followers' do
    get "get user's followers" do
      tags 'Users'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      security [Bearer: []]

      PaginationGenerator.parameters(binding)

      parameter name: 'sort',
                in: :query,
                description: 'Sort by',
                type: :string, enum: %w[username -username email -email created_at -created_at
                                        follow_count -follow_count followers_count -followers_count],
                example: '-created_at',
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

      before do
        users = create_list(:user, 3, :with_user_role)
        users.each { |u| u.follow user }
      end

      response 200, 'successful' do
        schema Schemas::Response::Users::Index.ref
        PaginationGenerator.headers(binding)

        let!(:user) { create(:user, :with_user_role) }
        let(:id) { user.id }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }
        let!(:user) { create(:user, :with_user_role) }
        let(:id) { user.id }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 404, 'user not found' do
        schema Schemas::Response::Users::Show404.ref

        let(:id) { -1 }
        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end
    end
  end

  test_block = lambda do
    tags 'Users'
    produces 'application/json'

    parameter name: :id, in: :path, type: :string

    security [Bearer: []]

    PaginationGenerator.parameters(binding)

    before do
      create_list(:user, 3, :with_user_role).each { |u| user.follow u }
      %w[first second third].each { |word| create(:post, body: "It's ##{word} hashtag") }
      Tag.where(name: %w[first second third]).each { |t| user.follow t }
    end

    response 200, 'successful' do
      schema Schemas::Response::Users::Following.ref
      PaginationGenerator.headers(binding)

      let!(:user) { create(:user, :with_user_role) }
      let(:id) { user.id }
      let(:Authorization) { ApiHelper.authenticated_header(user:) }
      include_context 'with swagger test'
    end

    response 400, 'invalid pagination' do
      schema Schemas::PaginationError.ref

      let(:'page[number]') { -1 }
      let!(:user) { create(:user, :with_user_role) }
      let(:id) { user.id }
      let(:Authorization) { ApiHelper.authenticated_header(user:) }
      include_context 'with swagger test'
    end

    response 404, 'user not found' do
      schema Schemas::Response::Users::Show404.ref

      let(:id) { -1 }
      let!(:user) { create(:user, :with_user_role) }
      let(:Authorization) { ApiHelper.authenticated_header(user:) }
      include_context 'with swagger test'
    end
  end

  path '/users/{id}/following' do
    get "get user's followings", &test_block
  end

  path '/users/{id}/following/users' do
    get "get user's followings users", &test_block
  end

  path '/users/{id}/following/tags' do
    get "get user's followings tags", &test_block
  end

  path '/users/search' do
    get 'search users' do
      tags 'Users'
      produces 'application/json'

      parameter name: :q, in: :query, type: :string

      security [Bearer: []]

      PaginationGenerator.parameters(binding)

      before do
        User.searchkick_index.delete
        create(:user, :with_user_role, username: 'SuperJack')
        create(:user, :with_user_role, username: 'Maxim')
        create(:user, :with_user_role, username: 'NAGIBATOR')
        User.reindex
      end

      response 200, 'successful' do
        schema Schemas::Response::Users::Index.ref
        PaginationGenerator.headers(binding)

        let!(:user) { create(:user, :with_user_role) }
        before { user.follow(User.find_by(username: 'Maxim')) }

        let(:q) { 'Max' }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }
        let(:q) { 'Max' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user, :with_user_role)) }
        include_context 'with swagger test'
      end
    end
  end
end
