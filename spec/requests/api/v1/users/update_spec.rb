# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Update', type: :request do
  describe 'PUT /users/:id' do
    context 'with email' do
      context 'when email is valid' do
        context 'with changed email' do
          before do
            user = create(:user, :with_moderator_role)
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

          it 'changes user role' do
            expect(JSON.parse(response.body)['data']['attributes']['role']['name']).to eq('unconfirmed')
            expect(User.last.role_before_reconfirm_value).to eq(Role.value_for(:moderator))
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

    context 'with roles' do
      context 'when roles is valid' do
        before do
          user = create(:user, :with_admin_role)
          another_user = create(:user, :with_user_role)
          headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
          put "/api/v1/users/#{another_user.id}", headers:, params: {
            data: { type: 'user', attributes: { role: 'premium' } }
          }
        end

        it 'updates user role' do
          expect(response).to have_http_status(:ok)
          data = JSON.parse(response.body)['data']
          expect(data['attributes']['role']['name']).to eq('premium')
        end
      end

      context 'with invalid role' do
        context 'when no such role' do
          before do
            user = create(:user, :with_admin_role)
            another_user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{another_user.id}", headers:, params: {
              data: { type: 'user', attributes: { role: 'fake-role' } }
            }
          end

          it 'fails with 404 not found' do
            expect(response).to have_http_status(:not_found)
            error = JSON.parse(response.body)['errors'][0]
            expect(error['title']).to eq('Not Found')
            expect(error['detail'][0]).to start_with('No such role: fake-role.')
          end
        end

        context 'when user is not moderator' do
          before do
            user = create(:user, :with_user_role)
            another_user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{another_user.id}", headers:, params: {
              data: { type: 'user', attributes: { role: 'banned' } }
            }
          end

          it 'fails with 403 forbidden' do
            expect(response).to have_http_status(:forbidden)
            error = JSON.parse(response.body)['errors'][0]
            expect(error['detail'][0]).to eq('User must be at least a moderator')
          end
        end

        context 'when user is same' do
          before do
            user = create(:user, :with_admin_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{user.id}", headers:, params: {
              data: { type: 'user', attributes: { role: 'banned' } }
            }
          end

          it 'fails with 403 forbidden' do
            expect(response).to have_http_status(:forbidden)
            error = JSON.parse(response.body)['errors'][0]
            expect(error['detail'][0]).to eq('You cant update your own role')
          end
        end

        context 'when role is higher then yours' do
          before do
            user = create(:user, :with_moderator_role)
            another_user = create(:user, :with_user_role)
            headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
            put "/api/v1/users/#{another_user.id}", headers:, params: {
              data: { type: 'user', attributes: { role: 'admin' } }
            }
          end

          it 'fails with 403 forbidden' do
            expect(response).to have_http_status(:forbidden)
            error = JSON.parse(response.body)['errors'][0]
            expect(error['detail'][0]).to eq('You cant assign role higher then yours')
          end
        end
      end
    end
  end
end
