require 'swagger_helper'

RSpec.describe 'api/v1/comments', type: :request do
  path '/comments' do
    post 'create comment' do
      tags 'Comments'
      description 'Create comments'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Comments::Create.ref

      response 201, 'created successful' do
        schema Schemas::Response::Comments::Create.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:commentable) { create(:post, user:) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          {
            data: {
              type: 'comments',
              attributes: {
                body: Faker::Lorem.paragraph(sentence_count: 2),
                commentable_type: 'Post',
                commentable_id: commentable.id
              }
            }
          }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let!(:commentable) { create(:post, user:) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          {
            data: {
              type: 'comments',
              attributes: {
                body: Faker::Lorem.paragraph(sentence_count: 2),
                commentable_type: 'Post',
                commentable_id: commentable.id
              }
            }
          }
        end

        include_context 'with swagger test'
      end

      response 422, 'validation error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:commentable) { create(:post, user:) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          {
            data: {
              type: 'comments',
              attributes: {
                body: Faker::Lorem.paragraph(sentence_count: 2) * 10_000,
                commentable_type: 'Post',
                commentable_id: commentable.id
              }
            }
          }
        end

        include_context 'with swagger test'
      end
    end
  end

  path '/comments/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'show comment' do
      tags 'Comments'
      description 'Show comment'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'comment found' do
        schema Schemas::Response::Comments::Show.ref

        let(:id) { create(:comment).id }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end

      response 404, 'comment not found' do
        schema Schemas::Response::Error.ref

        let(:id) { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end

    %w[patch put].each do |req|
      public_send req, 'update comment' do
        tags 'Comments'
        description 'Update comment'

        security [Bearer: []]

        consumes 'application/json'
        produces 'application/json'

        parameter name: :data, in: :body, schema: Schemas::Parameter::Comments::Update.ref

        response 200, 'successful' do
          schema Schemas::Response::Comments::Show.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:comment) { create(:comment, user:) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }

          let(:id) { comment.id }
          let(:data) do
            { data: { type: 'comment', attributes: { body: "#{comment.body} | updated!" } } }
          end

          include_context 'with swagger test'
        end

        response 401, 'unauthorized' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:comment) { create(:comment, user:) }
          let(:Authorization) { 'Bearer 123' }

          let(:id) { comment.id }
          let(:data) do
            { data: { type: 'comment', attributes: { body: 'comment' } } }
          end
          include_context 'with swagger test'
        end

        response 403, 'forbidden user' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:another_user) { create(:user, :with_user_role) }

          let!(:comment) { create(:comment, user: another_user) }
          let(:Authorization) { ApiHelper.authenticated_header(user:) }

          let(:id) { comment.id }
          let(:data) do
            { data: { type: 'comment', attributes: { body: 'comment' } } }
          end
          include_context 'with swagger test'
        end

        response 404, 'comment not found' do
          schema Schemas::Response::Error.ref

          let(:id) { -1 }
          let(:Authorization) { 'token' }
          let(:data) do
            { data: { type: 'comment', attributes: { body: 'comment' } } }
          end
          include_context 'with swagger test'
        end

        response 422, 'validation error' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:comment) { create(:comment, user:) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }

          let(:id) { comment.id }
          let(:data) do
            { data: { type: 'comment', attributes: { body: comment.body * 10_000 } } }
          end
          include_context 'with swagger test'
        end
      end
    end

    delete 'delete comment' do
      tags 'Comments'
      description 'Delete comment'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'successful' do
        schema Schemas::Response::Comments::Destroy.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:comment) { create(:comment, user:) }

        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:id) { comment.id }
        include_context 'with swagger test'
      end

      response 401, 'unauthorized' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:comment) { create(:comment, user:) }
        let(:Authorization) { 'Bearer 123' }

        let(:id) { comment.id }
        include_context 'with swagger test'
      end

      response 403, 'forbidden user' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:another_user) { create(:user, :with_user_role) }

        let!(:comment) { create(:comment, user: another_user) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:id) { comment.id }
        include_context 'with swagger test'
      end

      response 404, 'comment not found' do
        schema Schemas::Response::Error.ref

        let(:id) { -1 }
        let(:Authorization) { 'token' }
        include_context 'with swagger test'
      end
    end
  end
end
