# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Update', type: :request do
  describe 'PUT /users/:id' do
    context 'with email' do
      context 'when email is valid' do
        context 'with changed email' do
          before do
            user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{user.id}", headers:, params: {
              data: { type: 'user', attributes: { email: 'NewEmail1@mail.com' } }
            }
          end

          it 'updates user email' do
            expect(response).to have_http_status(:ok)
            data = JSON.parse(response.body)['data']
            expect(data['attributes']['email']).to eq('NewEmail1@mail.com')
          end

          it 'adds a confirmation message' do
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['meta']['message']).to eq(
              'You have changed your email. Please verify your account. ' \
              'We sent a confirmation link to NewEmail1@mail.com'
            )
          end

          it 'sends confirmation mail to user' do
            expect(response).to have_http_status(:ok)
            expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
          end
        end

        context 'with unchanged email' do
          before do
            user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{user.id}", headers:, params: {
              data: { type: 'user', attributes: { email: user.email.upcase } }
            }
          end

          it 'does not add a confirmation message' do
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['meta']['message']).to eq(
              'You successfully updated user'
            )
          end

          it 'does not send confirmation mail to user' do
            expect(response).to have_http_status(:ok)
            expect(ActionMailer::MailDeliveryJob).not_to have_been_enqueued
          end
        end
      end

      context 'with invalid email' do
        context 'when email already exists' do
          it 'fails with 422 status' do
            user = create(:user, :with_user_role)
            another_user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{user.id}", headers:, params: {
              data: { type: 'user', attributes: { email: another_user.email } }
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['errors'][0]['detail']).to eq(['Email has already been taken'])
          end
        end

        context 'when email format is invalid' do
          before do
            user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{user.id}", headers:, params: {
              data: { type: 'user', attributes: { email: 'bad email' } }
            }
          end

          it 'fails with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['errors'][0]['detail']).to eq(['Email is invalid'])
          end

          it 'does not send confirmation mail to user' do
            expect(ActionMailer::MailDeliveryJob).not_to have_been_enqueued
          end
        end
      end
    end
  end
end
