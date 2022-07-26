require 'swagger_helper'

RSpec.describe 'api/v1/versions', type: :request do
  path '/versions' do
    get 'list versions' do
      tags 'Versions'
      description 'Get versions'

      security [Bearer: []]

      produces 'application/json'

      PaginationGenerator.parameters(binding)

      parameter name: 'sort',
                in: :query,
                description: 'Sort by',
                type: :string, enum: %w[v -v created_at -created_at],
                example: '-created_at',
                required: false

      response 200, 'successful' do
        schema Schemas::Response::Versions::Index.ref
        PaginationGenerator.headers(binding)

        before { create_list(:version, 4) }

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

    post 'create version' do
      tags 'Versions'
      description 'Create versions'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Versions::Create.ref

      response 201, 'created successful' do
        schema Schemas::Response::Versions::Show.ref

        let!(:user) { create(:user, :with_dev_role) }
        let!(:version) { create(:version, for_role: 'moderator') }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'version', attributes: {
            v: '101.1.1',
            link: version.link,
            size: version.size,
            for_role: version.for_role,
            whats_new: version.whats_new
          } } }
        end

        include_context 'with swagger test'
      end

      response 401, 'user is suspended' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_banned_role) }
        let!(:version) { create(:version, for_role: 'moderator') }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'version', attributes: {
            v: '101.1.2',
            link: version.link,
            size: version.size,
            for_role: version.for_role,
            whats_new: version.whats_new
          } } }
        end

        include_context 'with swagger test'
      end

      response 403, 'not enough permissions' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:version) { create(:version, for_role: 'moderator') }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'version', attributes: {
            v: '101.1.3',
            link: version.link,
            size: version.size,
            for_role: version.for_role,
            whats_new: version.whats_new
          } } }
        end

        include_context 'with swagger test'
      end

      response 422, 'validation error' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_dev_role) }
        let!(:version) { create(:version, for_role: 'moderator') }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:data) do
          { data: { type: 'version', attributes: {
            v: version.v,
            link: version.link,
            size: version.size,
            for_role: version.for_role,
            whats_new: version.whats_new
          } } }
        end

        include_context 'with swagger test'
      end
    end
  end

  path '/versions/{v}' do
    parameter name: :v, in: :path, schema: {
      type: :string,
      title: 'Version',
      pattern: '^(?:(\d+)\.)?(?:(\d+)\.)?(\d+)$'
    }, description: 'Version'

    get 'show version' do
      tags 'Versions'
      description 'Show version'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'version found' do
        schema Schemas::Response::Versions::Show.ref

        let!(:user) { create(:user, :with_admin_role) }
        let!(:version) { create(:version, for_role: 'admin') }
        let(:v) { version.v }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 403, 'not enough permissions' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:version) { create(:version, for_role: 'admin') }
        let(:v) { version.v }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 404, 'version not found' do
        schema Schemas::Response::Error.ref

        let(:v) { '1000.10000.1000' }
        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
        include_context 'with swagger test'
      end
    end

    %w[patch put].each do |req|
      public_send req, 'update version' do
        tags 'Versions'
        description 'Update version'

        security [Bearer: []]

        consumes 'application/json'
        produces 'application/json'

        parameter name: :data, in: :body, schema: Schemas::Parameter::Versions::Update.ref

        response 200, 'successful' do
          schema Schemas::Response::Versions::Show.ref

          let!(:user) { create(:user, :with_dev_role) }
          let!(:version) { create(:version) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }
          let(:v) { version.v }
          let(:data) do
            { data: { type: 'version', attributes: { whats_new: "#{version.whats_new} | updated!" } } }
          end

          include_context 'with swagger test'
        end

        response 401, 'unauthorized' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_dev_role) }
          let!(:version) { create(:version) }

          let(:Authorization) { 'Bearer 123' }
          let(:v) { version.v }
          let(:data) do
            { data: { type: 'version', attributes: { whats_new: "#{version.whats_new} | updated!" } } }
          end
          include_context 'with swagger test'
        end

        response 403, 'not enough permissions' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_user_role) }
          let!(:version) { create(:version) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }
          let(:v) { version.v }
          let(:data) do
            { data: { type: 'version', attributes: { whats_new: "#{version.whats_new} | updated!" } } }
          end
          include_context 'with swagger test'
        end

        response 404, 'version not found' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_dev_role) }
          let!(:version) { create(:version) }

          let(:v) { '9999.10000.1000' }
          let(:Authorization) { ApiHelper.authenticated_header(user:) }
          let(:data) do
            { data: { type: 'version', attributes: { whats_new: "#{version.whats_new} | updated!" } } }
          end
          include_context 'with swagger test'
        end

        response 422, 'validation error' do
          schema Schemas::Response::Error.ref

          let!(:user) { create(:user, :with_dev_role) }
          let!(:version) { create(:version) }

          let(:Authorization) { ApiHelper.authenticated_header(user:) }
          let(:v) { version.v }
          let(:data) do
            { data: { type: 'version', attributes: { whats_new: '' } } }
          end
          include_context 'with swagger test'
        end
      end
    end

    delete 'delete version' do
      tags 'Versions'
      description 'Delete version'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'successful' do
        schema Schemas::Response::Versions::Destroy.ref

        let!(:user) { create(:user, :with_dev_role) }
        let!(:version) { create(:version) }

        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        let(:v) { version.v }
        include_context 'with swagger test'
      end

      response 401, 'unauthorized' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_dev_role) }
        let!(:version) { create(:version) }
        let(:Authorization) { 'Bearer 123' }

        let(:v) { version.v }
        include_context 'with swagger test'
      end

      response 403, 'not enough permissions' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_user_role) }
        let!(:version) { create(:version) }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }

        let(:v) { version.v }
        include_context 'with swagger test'
      end

      response 404, 'version not found' do
        schema Schemas::Response::Error.ref

        let!(:user) { create(:user, :with_dev_role) }
        let(:v) { '9999.10000.1000' }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end
    end
  end
end
