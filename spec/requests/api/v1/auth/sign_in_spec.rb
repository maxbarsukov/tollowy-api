# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign In', type: :request do
  describe 'POST /auth/sign_in' do
    context 'with email' do
      it 'signs in with valid email' do
        user = create(:user, :with_user_role)
        post '/api/v1/auth/sign_in', params: {
          data: {
            type: 'auth',
            attributes: { username_or_email: user.email, password: 'Password11' }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['attributes']['me']['attributes']['username']).to eq(user.username)
      end

      it 'fails with invalid email' do
        user = create(:user, :with_user_role)
        post '/api/v1/auth/sign_in', params: {
          data: {
            type: 'auth',
            attributes: { username_or_email: user.email, password: 'Password22' }
          }
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq('Invalid credentials')
      end
    end

    context 'with username' do
      it 'signs in with valid username' do
        user = create(:user, :with_user_role)
        post '/api/v1/auth/sign_in', params: {
          data: {
            type: 'auth',
            attributes: { username_or_email: user.username, password: 'Password11' }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['attributes']['me']['attributes']['email']).to eq(user.email)
      end

      it 'fails with invalid username' do
        user = create(:user, :with_user_role)
        post '/api/v1/auth/sign_in', params: {
          data: {
            type: 'auth',
            attributes: { username_or_email: user.username, password: 'Password22' }
          }
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq('Invalid credentials')
      end
    end
  end
end
