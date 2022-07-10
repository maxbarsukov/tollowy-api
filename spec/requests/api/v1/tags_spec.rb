require 'swagger_helper'

RSpec.describe 'api/v1/tags', type: :request do
  path '/tags' do
    get 'list tags' do
      tags 'Tags'
      description 'Get tags'

      security [Bearer: []]

      produces 'application/json'

      PaginationGenerator.parameters(binding)

      parameter name: 'sort',
                in: :query,
                description: 'Sort by (body, -body, updated_at, -updated_at, ' \
                             'followers_count, -followers_count, taggings_count, -taggings_count)',
                type: :string,
                default: '-updated_at',
                required: false

      parameter name: 'filter[name]', in: :query,
                description: 'Filter by name contains',
                type: :string, required: false

      parameter name: 'filter[updated_at[before]]', in: :query,
                description: 'Filter by updated before date',
                type: :string, required: false

      parameter name: 'filter[updated_at[after]]', in: :query,
                description: 'Filter by updated after date',
                type: :string, required: false

      response 200, 'successful' do
        schema Schemas::Response::Tags::Index.ref
        PaginationGenerator.headers(binding)

        before { create(:post, body: 'Hello! #tag #anothertag #followy') }

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

  path '/tags/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'show tag' do
      tags 'Tags'
      description 'Show tag'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'tag found' do
        description 'Finds tag by name'
        schema Schemas::Response::Tags::Show.ref

        before { create(:post, body: 'Hello! #tag #anothertag #followy') }

        let(:id) { Tag.first.name }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end

      response 404, 'tag not found' do
        schema Schemas::Response::Error.ref

        let(:id) { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end
  end
end
