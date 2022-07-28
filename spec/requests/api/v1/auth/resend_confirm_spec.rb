# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resend Confirmation Mail', type: :request do
  describe 'GET /auth/resend_confirm' do
    let!(:user) { create(:user, :with_admin_role) }

    context 'when unauthorized' do
      it 'fails with 401 status' do
        headers = { 'Authorization' => 'Bearer bad-token' }
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'You need to sign in or sign up before continuing'
        )
      end
    end

    context 'when time not passed' do
      it 'fails with 403 status' do
        headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
        PossessionToken.create!(user_id: user.id, value: '123', created_at: 30.seconds.ago)
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['errors'][0]['title']).to start_with(
          'The time between two confirmation mail'
        )
      end
    end

    context 'when no confirmations sent' do
      it 'fails with 409 status' do
        headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'There are no unconfirmed mails. You have nothing to verify'
        )
      end
    end

    context 'when successfully' do
      it 'returns 200 status' do
        headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
        PossessionToken.create!(user_id: user.id, value: '123', created_at: 1.hour.ago)
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['meta']['message']).to eq(
          'Confirmation mail sent'
        )
      end

      it 'destroys old token' do
        headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
        token = PossessionToken.create!(user_id: user.id, value: '123', created_at: 1.hour.ago)
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(PossessionToken.find_by(id: token.id)).to be_nil
      end

      it 'creates new token' do
        headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
        PossessionToken.create!(user_id: user.id, value: '123', created_at: 1.hour.ago)

        time = Time.current
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(user.possession_tokens.count).to eq(1)
        expect(user.possession_tokens.order(created_at: :desc).first.created_at >= time).to be_truthy
      end

      it 'sends email' do
        headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
        PossessionToken.create!(user_id: user.id, value: '123', created_at: 1.hour.ago)
        get '/api/v1/auth/resend_confirm', headers: headers

        expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
      end
    end
  end
end
