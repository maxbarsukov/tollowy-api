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
                username_or_email: '0@mail.com',
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
                username_or_email: user.email
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
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
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

  path '/auth/resend_confirm' do
    get 'Resend confirmation mail to user' do
      tags 'Auth'
      description 'Resend confirmation mail'

      produces 'application/json'

      security [Bearer: []]

      response 200, 'successful' do
        schema Schemas::Response::Auth::ResendConfirm.ref

        let!(:user) { create :user, :with_admin_role }
        let!(:possession_token) do
          PossessionToken.create!(user_id: user.id, value: '123456789').tap do |token|
            token.created_at = 1.hour.ago
            token.save!
          end
        end

        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 401, 'unauthorized' do
        schema Schemas::Response::Error.ref

        let(:Authorization) { 'Bearer 12345667' }
        include_context 'with swagger test'
      end

      response 403, 'time not passed' do
        schema Schemas::Response::Error.ref

        let!(:user) { create :user, :with_admin_role }
        let!(:possession_token) do
          PossessionToken.create!(user_id: user.id, value: '123456789').tap do |token|
            token.created_at = 22.seconds.ago
            token.save!
          end
        end

        let(:Authorization) { ApiHelper.authenticated_header(user:) }
        include_context 'with swagger test'
      end

      response 409, 'no confirmations sent' do
        schema Schemas::Response::Error.ref

        let!(:user) { create :user, :with_admin_role }
        let(:Authorization) { ApiHelper.authenticated_header(user:) }
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

        let!(:user) do
          create :user, :with_admin_role, role_before_reconfirm_value: Role.value_for(:admin)
        end
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

      response 401, 'Confirmation token expired' do
        schema Schemas::Response::Error.ref

        let!(:user) { create :user, :with_admin_role }
        let!(:possession_token) do
          PossessionToken.create!(
            user_id: user.id,
            value: '123456789',
            created_at: 1.day.ago
          )
        end

        let(:confirmation_token) { '123456789' }
        include_context 'with swagger test'
      end

      response 422, 'Missing params' do
        schema Schemas::ParamIsMissing.ref

        let(:confirmation_token) { '' }
        include_context 'with swagger test'
      end
    end
  end

  path '/auth/refresh' do
    get 'Refresh tokens' do
      tags 'Auth'
      description 'Refresh tokens with refresh_token in header'

      security [Bearer: []]

      produces 'application/json'

      response 200, 'successful' do
        schema Schemas::Auth.ref

        let!(:user) { create(:user, :with_user_role) }
        let(:Authorization) { "Bearer #{ApiHelper.refresh_token(user:)}" }

        include_context 'with swagger test'
      end

      response 401, 'invalid credentials' do
        schema Schemas::InvalidCredentialsError.ref

        let(:Authorization) { ApiHelper.authenticated_header(user: create(:user)) }
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

  path '/auth/providers/github' do
    post 'Sign In with GitHub' do
      tags 'Auth'
      description 'Sign In with GitHub.<br><b>token</b>: &#42; Base64 encoded GitHub access_token'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :token, in: :query, schema: { type: :string, required: true }

      before do
        user_response = {
          id: '12', login: 'maxbarsukov', bio: 'My bio', blog: 'maxbarsukov.vercel.app', location: 'A, B'
        }
        allow_any_instance_of(GithubAdapter).to(
          receive(:user).and_return(Response::Github::UserResponse.new(user_response))
        )
        user_emails_response = [{ email: 'maxbarsukov@bk.ru', verified: true, primary: true, visibility: true }]
        allow_any_instance_of(GithubAdapter).to(
          receive(:user_emails).and_return(Response::Github::UserEmailsResponse.new(user_emails_response))
        )
      end

      response 200, 'logged in successfully. User with this provider already exists' do
        schema Schemas::Response::Auth::Provider.ref

        before do
          user = create(:user, :with_admin_role, username: 'maxbarsukov', email: 'maxbarsukov@bk.ru')
          user.providers.create!(name: 'github', uid: '12')
        end

        let!(:token) { Base64.strict_encode64('github_token_stub') }
        include_context 'with swagger test'
      end

      response 201, 'signed in successfully. User with this provider has been created' do
        schema Schemas::Response::Auth::Provider.ref

        let!(:token) { Base64.strict_encode64('github_token_stub') }
        include_context 'with swagger test'
      end

      response 422, 'token encoding is broken or user parameters are not valid' do
        schema Schemas::Response::Error.ref

        let!(:token) { 'not-base64-string' }
        include_context 'with swagger test'
      end

      response 424, 'Error at dependent service (Github error response or no connection)' do
        schema Schemas::Response::Error.ref

        before do
          allow_any_instance_of(GithubAdapter).to(receive(:user).and_raise(Faraday::TimeoutError))
        end

        let!(:token) { Base64.strict_encode64('github_token_stub') }
        include_context 'with swagger test'
      end
    end
  end

  path '/auth/providers/vk' do
    post 'Sign In with VK' do
      tags 'Auth'
      description 'Sign In with VK.' \
                  '<br><b>vk_code</b>: &#42; Base64 encoded VK code' \
                  '<br><b>vk_redirect_uri</b>: &#42; VK OAuth App Redirect URI' \
                  '<br><b>email</b>: Email you must pass if VK dont provides your mail'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :vk_code, in: :query, schema: { type: :string, required: true }
      parameter name: :vk_redirect_uri, in: :query, schema: { type: :string, required: true }
      parameter name: :email, in: :query, schema: { type: :string, required: false }

      before do
        response = { user_id: '123', access_token: 'aaa', email: 'maxbarsukov@bk.ru' }
        allow_any_instance_of(VkAdapter).to(
          receive(:access_token).and_return(Response::Vk::AccessTokenResponse.new(response))
        )

        user_response = {
          response: [
            {
              id: '123', screen_name: 'maxbarsukov', first_name: 'Max', last_name: 'Barsukov',
              status: 'My status', about: 'My about', site: 'https://maxbarsukov.vercel.app'
            }
          ]
        }
        allow_any_instance_of(VkAdapter).to(
          receive(:user_get).and_return(Response::Vk::UserGetResponse.new(user_response))
        )
      end

      response 200, 'logged in successfully. User with this provider already exists' do
        schema Schemas::Response::Auth::Provider.ref

        before do
          user = create(:user, :with_admin_role, username: 'maxbarsukov', email: 'maxbarsukov@bk.ru')
          user.providers.create!(name: 'vk', uid: '123')
        end

        let!(:vk_code) { Base64.strict_encode64('my_code') }
        let!(:vk_redirect_uri) { 'http://localhost:5000/callback_vk' }
        let!(:email) { '' }
        include_context 'with swagger test'
      end

      response 201, 'signed in successfully. User with this provider has been created' do
        schema Schemas::Response::Auth::Provider.ref

        let!(:vk_code) { Base64.strict_encode64('my_code') }
        let!(:vk_redirect_uri) { 'http://localhost:5000/callback_vk' }
        let!(:email) { '' }
        include_context 'with swagger test'
      end

      response 422, 'token encoding is broken or user parameters are not valid' do
        schema Schemas::Response::Error.ref

        let!(:vk_code) { 'not-base64-string' }
        let!(:vk_redirect_uri) { 'http://localhost:5000/callback_vk' }
        let!(:email) { '' }
        include_context 'with swagger test'
      end

      response 424, 'Error at dependent service (VK error response or no connection)' do
        schema Schemas::Response::Error.ref

        before do
          allow_any_instance_of(VkAdapter).to(receive(:access_token).and_raise(Faraday::TimeoutError))
        end

        let!(:vk_code) { Base64.strict_encode64('my_code') }
        let!(:vk_redirect_uri) { 'http://localhost:5000/callback_vk' }
        let!(:email) { '' }
        include_context 'with swagger test'
      end
    end
  end
end
