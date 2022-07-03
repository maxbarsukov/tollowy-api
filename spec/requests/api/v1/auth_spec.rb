require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/auth/sign_in' do
    post 'Sign In' do
      tags 'Auth'
      description 'Sign In'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Auth::SignIn.ref

      response 200, 'successful' do
        schema Schemas::Response::Auth::SignIn.ref

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

      response 401, 'invalid credentials' do
        schema Schemas::InvalidCredentialsError.ref

        let!(:user) { create(:user, :with_user_role, :with_known_data) }
        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                email: user.email
              }
            }
          }
        end
        include_context 'with swagger test'
      end

      response 422, 'param is missing' do
        schema Schemas::ParamIsMissing.ref

        let(:data) do
          { data: { type: 'auth' } }
        end
        include_context 'with swagger test'
      end
    end
  end

  path '/auth/sign_up' do
    post 'Sign Up' do
      tags 'Auth'
      description 'Sign Up'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Auth::SignUp.ref

      response 201, 'created' do
        schema Schemas::Response::Auth::SignUp.ref

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

  path '/auth/sign_out' do
    delete 'Sign Out' do
      tags 'Auth'
      description 'Sign Out'

      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :everywhere, in: :query, schema: Schemas::Parameter::Auth::SignOut.ref

      response 200, 'successful' do
        schema Schemas::Response::Auth::SignOut.ref

        let!(:user) { create :user }
        let(:Authorization) { ApiHelper.authenticated_header(user: user) }
        let(:everywhere) { 'true' }
        include_context 'with swagger test'
      end

      response 401, 'invalid credentials' do
        schema Schemas::InvalidCredentialsError.ref

        let!(:user) { create :user }
        let(:Authorization) { 'Bearer 111' }
        let(:everywhere) { 'true' }
        include_context 'with swagger test'
      end
    end
  end

  path '/auth/confirm' do
    get 'Confirm User' do
      tags 'Auth'
      description 'Confirm User'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :confirmation_token, in: :query, schema: {
        type: :string
      }

      response 200, 'successful' do
        schema Schemas::Response::Auth::Confirm.ref

        let!(:user) { create :user, :with_admin_role }
        let!(:possession_token) do
          PossessionToken.create!(
            user_id: user.id,
            value: '123456789'
          )
        end

        let(:confirmation_token) { '123456789' }
        include_context 'with swagger test'
      end

      response 400, 'Invalid value' do
        schema Schemas::InvalidValue.ref

        let(:confirmation_token) { '111' }
        include_context 'with swagger test'
      end

      response 422, 'Missing params' do
        schema Schemas::ParamIsMissing.ref

        let(:confirmation_token) { '' }
        include_context 'with swagger test'
      end
    end
  end

  path '/auth/request_password_reset' do
    post 'Request Password Reset' do
      tags 'Auth'
      description 'Request Password Reset'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Auth::RequestPasswordReset.ref

      response 200, 'instructions sent' do
        schema Schemas::Response::Auth::RequestPasswordReset.ref

        let(:user) { create(:user, :with_user_role) }
        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                email: user.email
              }
            }
          }
        end
        include_context 'with swagger test'
      end

      response 404, 'User with this email not found' do
        schema Schemas::Response::Error.ref

        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                email: 'a123456@mail.com'
              }
            }
          }
        end
        include_context 'with swagger test'
      end
    end
  end

  path '/auth/reset_password' do
    post 'Reset Password' do
      tags 'Auth'
      description 'Reset Password'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :data, in: :body, schema: Schemas::Parameter::Auth::ResetPassword.ref

      response 200, 'password reset successfully' do
        schema Schemas::Auth.ref

        let!(:user) { create :user, :with_admin_role, :with_reset_token }
        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                reset_token: user.password_reset_token,
                password: 'Aa1111'
              }
            }
          }
        end
        include_context 'with swagger test'
      end

      response 401, 'Invalid token' do
        schema Schemas::Response::Error.ref

        let(:data) do
          {
            data: {
              type: 'auth',
              attributes: {
                reset_token: '1',
                password: 'Aa1111'
              }
            }
          }
        end
        include_context 'with swagger test'
      end
    end
  end
end
