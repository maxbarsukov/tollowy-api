require 'swagger_helper'

RSpec.describe 'api/v1/votes', type: :request do
  path '/votes/like' do
    post 'like votable' do
      tags 'Votes'
      description 'Like votable'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Votes::Vote.ref

      response 200, 'successful' do
        schema Schemas::Response::Votes::Success.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:my_post) { create(:post) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: my_post.id } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: 1 } } }
        end

        include_context 'with swagger test'
      end

      response 404, 'votable not found' do
        schema Schemas::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: -1 } } }
        end
        include_context 'with swagger test'
      end

      response 422, 'invalid parameter error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_type: 'UnsupportedVotable' } } }
        end
        include_context 'with swagger test'
      end
    end

    delete 'unlike votable' do
      tags 'Votes'
      description 'Unlike votable'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Votes::Vote.ref

      response 200, 'successful' do
        schema Schemas::Response::Votes::Success.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let!(:my_post) { create(:post) }
        let!(:vote) { user.likes my_post }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: my_post.id } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: 1 } } }
        end

        include_context 'with swagger test'
      end

      response 404, 'votable not found' do
        schema Schemas::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: -1 } } }
        end
        include_context 'with swagger test'
      end

      response 422, 'invalid parameter error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_type: 'UnsupportedVotable' } } }
        end
        include_context 'with swagger test'
      end
    end
  end

  path '/votes/dislike' do
    post 'dislike votable' do
      tags 'Votes'
      description 'Dislike votable'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Votes::Vote.ref

      response 200, 'successful' do
        schema Schemas::Response::Votes::Success.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:my_post) { create(:post) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: my_post.id } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: 1 } } }
        end

        include_context 'with swagger test'
      end

      response 404, 'votable not found' do
        schema Schemas::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: -1 } } }
        end
        include_context 'with swagger test'
      end

      response 422, 'invalid parameter error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_type: 'UnsupportedVotable' } } }
        end
        include_context 'with swagger test'
      end
    end

    delete 'undislike votable' do
      tags 'Votes'
      description 'Undislike votable'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Votes::Vote.ref

      response 200, 'successful' do
        schema Schemas::Response::Votes::Success.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let!(:my_post) { create(:post) }
        let!(:vote) { user.dislikes my_post }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: my_post.id } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: 1 } } }
        end

        include_context 'with swagger test'
      end

      response 404, 'votable not found' do
        schema Schemas::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_id: -1 } } }
        end
        include_context 'with swagger test'
      end

      response 422, 'invalid parameter error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'vote', attributes: { votable_type: 'UnsupportedVotable' } } }
        end
        include_context 'with swagger test'
      end
    end
  end
end
