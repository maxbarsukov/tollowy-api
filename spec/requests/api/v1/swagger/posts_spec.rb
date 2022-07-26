require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do
  path '/posts' do
    get 'list posts' do
      tags 'Posts'
      description 'Get posts'

      security [Bearer: []]

      produces 'application/json'

      PaginationGenerator.parameters(binding)

      parameter name: 'sort',
                in: :query,
                description: 'Sort by',
                type: :string, enum: %w[body -body created_at -created_at],
                example: '-created_at',
                required: false

      parameter name: 'filter[body]', in: :query,
                description: 'Filter by body contains',
                type: :string, required: false

      parameter name: 'filter[created_at[before]]', in: :query,
                description: 'Filter by created before date',
                type: :string, required: false

      parameter name: 'filter[created_at[after]]', in: :query,
                description: 'Filter by created after date',
                type: :string, required: false

      response 200, 'successful' do
        schema Schemas::Response::Posts::Index.ref
        PaginationGenerator.headers(binding)

        before { create_list(:post, 2) }

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

    post 'create post' do
      tags 'Posts'
      description 'Create posts'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Posts::Create.ref

      response 201, 'created successful' do
        schema Schemas::Response::Posts::Show.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'post', attributes: { body: create(:post, user:).body } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'post', attributes: { body: create(:post, user:).body } } }
        end

        include_context 'with swagger test'
      end

      response 422, 'validation error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'post', attributes: { body: create(:post, user:).body * 1000 } } }
        end

        include_context 'with swagger test'
      end
    end
  end

  path '/posts/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'show post' do
      tags 'Posts'
      description 'Show post'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'post found' do
        schema Schemas::Response::Posts::Show.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:post) { create(:post, user:) }
        before { post.liked_by user }

        let(:id) { post.id }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 404, 'post not found' do
        schema Schemas::Response::Error.ref

        let(:id) { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end

    %w[patch put].each do |req|
      public_send req, 'update post' do
        tags 'Posts'
        description 'Update post'

        security [Bearer: []]

        consumes 'application/json'
        produces 'application/json'

        parameter name: :data, in: :body, schema: Schemas::Parameter::Posts::Create.ref

        response 200, 'successful' do
          schema Schemas::Response::Posts::Show.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:post) { create(:post, user:) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: "#{post.body} | updated!" } } }
          end

          include_context 'with swagger test'
        end

        response 401, 'unauthorized' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:post) { create(:post, user:) }
          let(:Authorization) { 'Bearer 123' }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: 'post' } } }
          end
          include_context 'with swagger test'
        end

        response 403, 'forbidden user' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:another_user) { create(:user, :with_user_role) }

          let!(:post) { create(:post, user: another_user) }
          let(:Authorization) { ApiHelper.authenticated_header(user:) }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: 'post' } } }
          end
          include_context 'with swagger test'
        end

        response 404, 'post not found' do
          schema Schemas::Response::Error.ref

          let(:id) { -1 }
          let(:Authorization) { 'token' }
          let(:data) do
            { data: { type: 'post', attributes: { body: 'post' } } }
          end
          include_context 'with swagger test'
        end

        response 422, 'validation error' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:post) { create(:post, user:) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: post.body * 10_000 } } }
          end
          include_context 'with swagger test'
        end
      end
    end

    delete 'delete post' do
      tags 'Posts'
      description 'Delete post'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'successful' do
        schema Schemas::Response::Posts::Destroy.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:post) { create(:post, user:) }

        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:id) { post.id }
        include_context 'with swagger test'
      end

      response 401, 'unauthorized' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:post) { create(:post, user:) }
        let(:Authorization) { 'Bearer 123' }

        let(:id) { post.id }
        include_context 'with swagger test'
      end

      response 403, 'forbidden user' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:another_user) { create(:user, :with_user_role) }

        let!(:post) { create(:post, user: another_user) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:id) { post.id }
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

  path '/posts/{id}/comments' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'get post comments' do
      tags 'Posts'
      description 'Get post comments'

      security [Bearer: []]

      produces 'application/json'

      PaginationGenerator.parameters(binding)

      response 200, 'successful' do
        schema Schemas::Response::Posts::Comment.ref
        PaginationGenerator.headers(binding)

        let!(:post) { create(:post) }
        before do
          5.times do |num|
            Comment.create!(
              commentable_id: post.id,
              commentable_type: 'Post',
              body: "comment#{num}",
              user_id: post.user_id
            )
          end
        end

        let(:id) { post.id }
        let(:Authorization) { ApiHelper.authenticated_header(user: User.find(post.user_id)) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:id) { create(:post).id }
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

  path '/posts/{id}/tags' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'get post tags' do
      tags 'Posts'
      description 'Get post tags'

      security [Bearer: []]

      produces 'application/json'

      PaginationGenerator.parameters(binding)

      response 200, 'successful' do
        schema Schemas::Response::Tags::Index.ref
        PaginationGenerator.headers(binding)

        let!(:post) { create(:post, body: 'My post, #hello to #everyone') }

        let(:id) { post.id }
        let(:Authorization) { ApiHelper.authenticated_header(user: User.find(post.user_id)) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:id) { create(:post).id }
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

  path '/posts/search' do
    get 'search posts' do
      tags 'Posts'
      produces 'application/json'

      parameter name: :q, in: :query, type: :string

      security [Bearer: []]

      PaginationGenerator.parameters(binding)

      before do
        create(:post, body: 'Hello, its me')
        create(:post, body: '#wow, super post')
        create(:post, body: 'you posting shit')
        create(:post, body: 'POST!')
        Post.searchkick_index.delete
        Post.reindex
      end

      response 200, 'successful' do
        schema Schemas::Response::Posts::Index.ref
        PaginationGenerator.headers(binding)

        let!(:user) { create(:user, :with_user_role) }
        before { Post.find_by(body: 'POST!').liked_by user }

        let(:q) { 'post' }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }
        let(:q) { 'post' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user, :with_user_role)) }
        include_context 'with swagger test'
      end
    end
  end

  path '/posts/{id}/comments/search' do
    get 'search posts' do
      tags 'Posts'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :q, in: :query, type: :string

      security [Bearer: []]

      PaginationGenerator.parameters(binding)

      let!(:post) { create(:post, body: 'Hello') }

      before do
        Post.searchkick_index.delete
        Comment.searchkick_index.delete
        user = create(:user, :with_user_role)
        post.comments.create!(user:, body: 'Hello, i love comments')
        post.comments.create!(user:, body: '#my #super #comment')
        post.comments.create!(user:, body: 'lmao bottom text')
        Post.reindex
        Comment.reindex
      end

      response 200, 'successful' do
        schema Schemas::Response::Comments::Index.ref
        PaginationGenerator.headers(binding)

        let!(:user) { create(:user, :with_user_role) }
        before { Comment.find_by(body: 'Hello, i love comments').liked_by user }

        let(:q) { 'comment' }
        let(:id) { post.id }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }
        let(:q) { 'comment' }
        let(:id) { post.id }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user, :with_user_role)) }
        include_context 'with swagger test'
      end

      response 404, 'post not found' do
        schema Schemas::Response::Error.ref

        let(:id) { -1 }
        let(:q) { 'comment' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end
  end
end
