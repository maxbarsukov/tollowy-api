require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/api/v1/auth/sign_in' do
    post 'Sign In' do
      tags 'Auth'
      description 'Sign In'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: {
        '$ref' => '#/components/schemas/parameter_auth_sign_in'
      }

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/response_auth_sign_in'

        let!(:user) { create(:user, :with_user_role, email: '0@mail.com', password: 'Aa1111') }
        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                email: '0@mail.com',
                password: 'Aa1111'
              }
            }
          }
        end
        include_context 'with swagger test'
      end
    end
  end

  path '/api/v1/auth/sign_up' do
    post 'Sign Up' do
      tags 'Auth'
      description 'Sign Up'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: {
        '$ref' => '#/components/schemas/parameter_auth_sign_up'
      }

      response 201, 'created' do
        schema '$ref' => '#/components/schemas/response_auth_sign_up'

        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                email: '0@mail.com',
                username: 'User000',
                password: 'Aa1111'
              }
            }
          }
        end
        include_context 'with swagger test'
      end
    end
  end

  path '/api/v1/auth/sign_out' do
    delete 'Sign Out' do
      tags 'Auth'
      description 'Sign Out'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :everywhere, in: :query, schema: {
        '$ref' => '#/components/schemas/parameter_auth_sign_out'
      }

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/response_auth_sign_out'

        let!(:user) { create :user }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        let(:everywhere) { 'true' }
        include_context 'with swagger test'
      end

      response 401, 'invalid credentials' do
        schema '$ref' => '#/components/schemas/invalid_credentials_error'

        let!(:user) { create :user }
        let(:Authorization) { 'Bearer 111' }
        let(:everywhere) { 'true' }
        include_context 'with swagger test'
      end
    end
  end

  path '/api/v1/auth/confirm' do
    get 'Confirm User' do
      tags 'Auth'
      description 'Confirm User'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :confirmation_token, in: :query, schema: {
        type: :string
      }

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/response_auth_confirm'

        let!(:user) { create :user, :with_admin_role }
        let!(:possession_token) do # rubocop:disable RSpec/LetSetup
          PossessionToken.create!(
            user_id: user.id,
            value: '123456789'
          )
        end

        let(:confirmation_token) { '123456789' }
        include_context 'with swagger test'
      end

      response 400, 'Invalid value' do
        schema '$ref' => '#/components/schemas/invalid_value'

        let(:confirmation_token) { '111' }
        include_context 'with swagger test'
      end

      response 422, 'Missing params' do
        schema '$ref' => '#/components/schemas/param_is_missing'

        let(:confirmation_token) { '' }
        include_context 'with swagger test'
      end
    end
  end
end
