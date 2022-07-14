require 'swagger_helper'

RSpec.describe 'api/v1/follows', type: :request do
  path '/follows' do
    post 'follow' do
      tags 'Follows'
      description 'Follow somebody'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Follows::Follow.ref

      response 200, 'successful' do
        schema Schemas::Response::Follows::Success.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:another_user) { create(:user, :with_user_role) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_id: another_user.id } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_id: 1 } } }
        end

        include_context 'with swagger test'
      end

      response 404, 'followable not found' do
        schema Schemas::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_id: -1 } } }
        end

        include_context 'with swagger test'
      end

      response 422, 'invalid parameter error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_type: 'UnsupportedFollowable' } } }
        end

        include_context 'with swagger test'
      end
    end

    delete 'unfollow' do
      tags 'Follows'
      description 'Stop following somebody'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Follows::Follow.ref

      response 200, 'successful' do
        schema Schemas::Response::Follows::Success.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let!(:another_user) { create(:user, :with_user_role) }
        let!(:follow) { user.follow another_user }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_id: another_user.id } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_id: 1 } } }
        end

        include_context 'with swagger test'
      end

      response 404, 'followable not found' do
        schema Schemas::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_id: -1 } } }
        end

        include_context 'with swagger test'
      end

      response 422, 'invalid parameter error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:data) do
          { data: { type: 'follow', attributes: { followable_type: 'UnsupportedFollowable' } } }
        end

        include_context 'with swagger test'
      end
    end
  end
end
