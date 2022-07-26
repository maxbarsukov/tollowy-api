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

  path '/tags/{id}/posts' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get 'get posts for tag' do
      tags 'Tags'
      description 'Get posts by tag'

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

      before do
        create(:post, body: 'My #tag')
        create(:post, body: 'Another post for #tag')
      end

      response 200, 'successful' do
        schema Schemas::Response::Posts::Index.ref
        PaginationGenerator.headers(binding)

        let(:id) { 'tag' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:id) { 'tag' }
        let(:'page[number]') { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end
  end

  path '/tags/{id}/followers' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get "tag's followers" do
      tags 'Tags'
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

      before do
        users = create_list(:user, 5, :with_user_role)
        tag = create(:post, body: 'My super #tag').tags.first
        users.each do |user|
          user.follow tag
        end
      end

      response 200, 'successful' do
        schema Schemas::Response::Users::Index.ref
        PaginationGenerator.headers(binding)

        let(:id) { 'tag' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:id) { 'tag' }
        let(:'page[number]') { -1 }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end
  end

  path '/tags/search' do
    get 'search tags' do
      tags 'Tags'
      produces 'application/json'

      parameter name: :q, in: :query, type: :string

      security [Bearer: []]

      PaginationGenerator.parameters(binding)

      before do
        create(:post, body: '#i #love #tags')
        create(:post, body: 'Stop #tagging every post!')
        Post.searchkick_index.delete
        Tag.searchkick_index.delete
        Post.reindex
        Tag.reindex
      end

      response 200, 'successful' do
        schema Schemas::Response::Tags::Index.ref
        PaginationGenerator.headers(binding)

        let!(:user) { create(:user, :with_user_role) }
        before { user.follow Tag.find_by(name: 'tagging') }

        let(:q) { 'tag' }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 400, 'invalid pagination' do
        schema Schemas::PaginationError.ref

        let(:'page[number]') { -1 }
        let(:q) { 'tagging' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user, :with_user_role)) }
        include_context 'with swagger test'
      end
    end
  end
end
