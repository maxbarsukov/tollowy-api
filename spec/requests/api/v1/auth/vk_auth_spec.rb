# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticate with VK', type: :request do
  describe 'POST vk_auth' do
    context 'with new user' do
      context 'when user has no email in vk' do
        context 'when new user does not pass own email' do
          before do
            ResponseStub = Struct.new(:status, :body)
            response = { user_id: '123', access_token: 'aaa' }
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

          it 'returns 422 status' do
            vk_code = Base64.strict_encode64('my_code')
            post '/api/v1/auth/providers/vk', params: {
              vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
              'No email provided by VK. Please, pass it as parameter'
            )
          end
        end

        context 'when user passes own email' do
          before do
            response = { user_id: '123', access_token: 'aaa' }
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

          context 'when user with this email already exists' do
            it 'returns 422 status' do
              create(:user, :with_user_role, email: 'max@mail.com')

              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk', email: 'max@mail.com'
              }

              expect(response).to have_http_status(:unprocessable_entity)
              expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq(
                'Email has already been taken'
              )
            end
          end

          context 'when user with this email does not exist' do
            before do
              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk', email: 'max@mail.com'
              }
            end

            it 'creates new user' do
              expect(response).to have_http_status(:ok)
              expect(User.count).to eq(1)
            end

            it 'sets VK attributes to new user' do
              expect(response).to have_http_status(:ok)
              expect(User.first).to have_attributes(
                username: 'maxbarsukov',
                role_value: -30,
                bio: 'My status. My about',
                blog: 'https://maxbarsukov.vercel.app',
                location: nil
              )
            end

            it 'generates new possession token' do
              expect(User.first.possession_tokens.count).to eq(1)
            end

            it 'sends new confirmation mail' do
              expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
            end

            it 'starts job to create user event' do
              expect(Events::CreateUserEventJob).to have_been_enqueued
            end

            it 'adds unconfirmed role' do
              expect(User.first.role_value).to eq(-30)
            end

            it 'add VK to user providers' do
              expect(User.first.providers).to include(Provider.find_by(name: 'vk', uid: '123'))
            end
          end
        end
      end
    end

    context 'with existing user and provider' do
      before do
        response = { user_id: '123', access_token: 'aaa' }
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

      it 'signs in as existing user' do
        user = create(:user, :with_user_role, username: 'MBarsukov')
        user.providers.create!(name: 'vk', uid: '123')

        expect(user.sign_in_count).to eq(0)

        vk_code = Base64.strict_encode64('my_code')

        expect do
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }
        end.not_to change(User, :count)

        expect do
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }
        end.to change { User.first.sign_in_count }.from(1).to(2)
      end
    end

    context 'when VK request is invalid' do
      context 'when code encoding is bad' do
        it 'returns 422 status' do
          post '/api/v1/auth/providers/vk', params: {
            vk_code: 'bad_response', vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors'][0]['title']).to eq("Bad base64 encoding. Can't decode VK code")
        end
      end

      context 'when response is incorrect' do
        before do
          response = ResponseStub.new('401', JSON.generate({ error_description: 'My error' }))
          allow_any_instance_of(VkAdapter).to(
            receive(:access_token).and_return(Response::Vk::AccessTokenError.new(response))
          )
        end

        it 'returns 424 status' do
          vk_code = Base64.strict_encode64('my_code')
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }

          expect(response).to have_http_status(:failed_dependency)
          expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq(
            'Request to oauth.vk.com failed with status 401. Message: My error'
          )
        end
      end

      context 'when no user id in VK response' do
        before do
          response = { access_token: 'access_token' }
          allow_any_instance_of(VkAdapter).to(
            receive(:access_token).and_return(Response::Vk::AccessTokenResponse.new(response))
          )
        end

        it 'returns 422 status' do
          vk_code = Base64.strict_encode64('my_code')
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
            "No user_id, can't authorize"
          )
        end
      end

      context 'when no access_token id in VK response' do
        before do
          response = { user_id: '123' }
          allow_any_instance_of(VkAdapter).to(
            receive(:access_token).and_return(Response::Vk::AccessTokenResponse.new(response))
          )
        end

        it 'returns 422 status' do
          vk_code = Base64.strict_encode64('my_code')
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
            "No access_token, can't authorize"
          )
        end
      end

      context 'when JSON answer is incorrect' do
        before do
          response = ResponseStub.new('400', 'haha, incorrect')
          allow_any_instance_of(VkAdapter).to(
            receive(:access_token).and_return(Response::Vk::AccessTokenError.new(response))
          )
        end

        it 'returns 424 status' do
          vk_code = Base64.strict_encode64('my_code')
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }

          expect(response).to have_http_status(:failed_dependency)
          expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq(
            'Request to oauth.vk.com failed with status 400. Body parsing failed'
          )
        end
      end

      context 'when VK timeout' do
        before do
          allow_any_instance_of(VkAdapter).to(receive(:access_token).and_raise(Faraday::TimeoutError))
        end

        it 'returns 424 status' do
          vk_code = Base64.strict_encode64('my_code')
          post '/api/v1/auth/providers/vk', params: {
            vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
          }

          expect(response).to have_http_status(:failed_dependency)
          expect(JSON.parse(response.body)['errors'][0]['title']).to eq('Timeout at dependent service')
        end
      end
    end
  end
end
