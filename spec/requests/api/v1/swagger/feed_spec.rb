require 'swagger_helper'

RSpec.describe 'api/v1/feed', type: :request do
  path '/feed' do
    get 'get feed' do
      tags 'Feed'
      description 'Get feed'

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

        let!(:user) { create(:user, :with_user_role) }

        before do
          users = create_list(:user, 3, :with_user_role)
          users.each { |u| create_list(:post, 5, user: u) }
          p1 = create(:post, body: 'Wow, #new #amazing #post')
          create(:post, body: '#new spider man is #amazing')
          p2 = create(:post, body: '#new #post for you')
          create(:post, body: 'This is my #post')

          user.follow Tag.find_by(name: 'post')
          user.likes p1
          user.likes p2
          users.each { |u| user.follow u }
        end

        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { 100 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user, :with_user_role)) }
        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end
    end
  end
end
