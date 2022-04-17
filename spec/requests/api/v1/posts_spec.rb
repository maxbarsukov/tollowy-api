require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do
  path '/posts' do
    get 'list posts' do
      tags 'Posts'
      description 'Get posts'

      produces 'application/json'

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/response_posts_get'

        before { create_list(:post, 2) }

        include_context 'with swagger test'
      end
    end

    post 'create post' do
      tags 'Posts'
      description 'Create posts'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: {
        '$ref' => '#/components/schemas/parameter_posts_create'
      }

      response 201, 'created successful' do
        schema '$ref' => '#/components/schemas/response_post'

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        let(:data) do
          { data: { type: 'post', attributes: { body: create(:post, user: user).body } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema '$ref' => '#/components/schemas/error'

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        let(:data) do
          { data: { type: 'post', attributes: { body: create(:post, user: user).body } } }
        end

        include_context 'with swagger test'
      end

      response 422, 'user is suspended' do
        schema '$ref' => '#/components/schemas/error'

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        let(:data) do
          { data: { type: 'post', attributes: { body: create(:post, user: user).body * 1000 } } }
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

      produces 'application/json'

      response 200, 'post found' do
        schema '$ref' => '#/components/schemas/response_post'

        let(:id) { create(:post).id }
        include_context 'with swagger test'
      end

      response 404, 'post not found' do
        schema '$ref' => '#/components/schemas/error'

        let(:id) { -1 }
        include_context 'with swagger test'
      end
    end

    %w[patch put].each do |req|
      public_send req, 'update post' do
        tags 'Posts'
        description 'Show post'

        security [Bearer: []]

        consumes 'application/json'
        produces 'application/json'

        parameter name: :data, in: :body, schema: {
          '$ref' => '#/components/schemas/parameter_posts_create'
        }

        response 200, 'successful' do
          schema '$ref' => '#/components/schemas/response_post'

          let!(:user) { create(:user, :with_user_role) }
          let!(:post) { create(:post, user: user) }

          let(:Authorization) { ApiHelper.authenticated_header(user: user) }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: "#{post.body} | updated!" } } }
          end

          include_context 'with swagger test'
        end

        response 401, 'unauthorized' do
          schema '$ref' => '#/components/schemas/error'

          let!(:user) { create(:user, :with_user_role) }
          let!(:post) { create(:post, user: user) }
          let(:Authorization) { 'Bearer 123' }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: 'post' } } }
          end
          include_context 'with swagger test'
        end

        response 403, 'forbidden user' do
          schema '$ref' => '#/components/schemas/error'

          let!(:user) { create(:user, :with_user_role) }
          let!(:another_user) { create(:user, :with_user_role) }

          let!(:post) { create(:post, user: another_user) }
          let(:Authorization) { ApiHelper.authenticated_header(user: user) }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: 'post' } } }
          end
          include_context 'with swagger test'
        end

        response 404, 'post not found' do
          schema '$ref' => '#/components/schemas/error'

          let(:id) { -1 }
          let(:Authorization) { 'token' }
          let(:data) do
            { data: { type: 'post', attributes: { body: 'post' } } }
          end
          include_context 'with swagger test'
        end

        response 422, 'validation error' do
          schema '$ref' => '#/components/schemas/error'

          let!(:user) { create(:user, :with_user_role) }
          let!(:post) { create(:post, user: user) }

          let(:Authorization) { ApiHelper.authenticated_header(user: user) }

          let(:id) { post.id }
          let(:data) do
            { data: { type: 'post', attributes: { body: post.body * 10_000 } } }
          end
          include_context 'with swagger test'
        end
      end
    end
  end
end
