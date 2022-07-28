# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Confirm', type: :request do
  describe 'GET /auth/confirm' do
    context 'without role_before_reconfirm_value' do
      context 'with valid token' do
        before { travel_to Time.zone.local(2022) }

        after { travel_back }

        it 'confirms user' do
          user = create(:user, :with_unconfirmed_role)
          token = PossessionToken.create!(user_id: user.id, value: 'hello-1')
          get "/api/v1/auth/confirm?confirmation_token=#{token.value}"

          expect(response).to have_http_status(:ok)
          user_attributes = JSON.parse(response.body)['data']['attributes']['me']['attributes']
          expect(user_attributes['username']).to eq(user.username)
          expect(user_attributes['role']['name']).to eq('user')
        end

        it 'updates confirmed_at' do
          time = Time.current
          user = create(:user, :with_unconfirmed_role)
          token = PossessionToken.create!(user_id: user.id, value: 'hello-1')
          get "/api/v1/auth/confirm?confirmation_token=#{token.value}"

          expect(User.last.confirmed_at).to eq(time)
        end

        it 'updates user role' do
          user = create(:user, :with_unconfirmed_role)
          token = PossessionToken.create!(user_id: user.id, value: 'hello-1')

          expect(User.last.role.name).to eq('unconfirmed')
          get "/api/v1/auth/confirm?confirmation_token=#{token.value}"
          expect(User.last.role.name).to eq('user')
        end
      end
    end

    context 'with role_before_reconfirm_value' do
      it 'confirms user' do
        user = build(:user, :with_unconfirmed_role)
        user.role_before_reconfirm_value = 50
        user.save!

        token = PossessionToken.create!(user_id: user.id, value: 'hello-1')
        get "/api/v1/auth/confirm?confirmation_token=#{token.value}"

        expect(response).to have_http_status(:ok)
        user_attributes = JSON.parse(response.body)['data']['attributes']['me']['attributes']
        expect(user_attributes['username']).to eq(user.username)
        expect(user_attributes['role']['name']).to eq('admin')
      end

      it 'updates user role' do
        user = build(:user, :with_unconfirmed_role)
        user.role_before_reconfirm_value = 100
        user.save!

        token = PossessionToken.create!(user_id: user.id, value: 'hello-1')

        expect(User.last.role.name).to eq('unconfirmed')
        get "/api/v1/auth/confirm?confirmation_token=#{token.value}"
        expect(User.last.role.name).to eq('dev')
        expect(User.last.role_before_reconfirm_value).to be_nil
      end
    end

    context 'with invalid token' do
      it 'fails' do
        get '/api/v1/auth/confirm?confirmation_token=hi'

        expect(response).to have_http_status(:bad_request)
        error = JSON.parse(response.body)['errors'][0]
        expect(error['title']).to eq('Invalid value, no such token')
      end
    end

    context 'with expired token' do
      it 'fails' do
        user = create(:user, :with_unconfirmed_role)
        token = PossessionToken.create!(user_id: user.id, value: 'hello-999', created_at: 1.day.ago)
        get "/api/v1/auth/confirm?confirmation_token=#{token.value}"

        expect(response).to have_http_status(:unauthorized)
        error = JSON.parse(response.body)['errors'][0]
        expect(error['title']).to eq('Confirmation token expired')
      end
    end
  end
end
