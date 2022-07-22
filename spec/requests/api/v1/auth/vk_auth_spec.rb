# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticate with VK', type: :request do
  describe 'POST vk_auth' do
    ResponseStub = Struct.new(:status, :body)

    context 'with new user' do
      context 'when user has vk email' do
        context 'when user with such email does not exists' do
          before do
            response = { user_id: '123', access_token: 'aaa', email: 'max@mail.com' }
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

            vk_code = Base64.strict_encode64('my_code')

            expect(User.count).to eq(0) # rubocop:disable RSpec/ExpectInHook
            post '/api/v1/auth/providers/vk', params: {
              vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
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
              email: 'max@mail.com',
              role_value: 0,
              bio: 'My status. My about',
              blog: 'https://maxbarsukov.vercel.app',
              location: nil
            )
          end

          it 'adds VK provider to new user' do
            expect(User.first.providers.count).to eq(1)
            expect(User.first.providers).to include(Provider.find_by(name: 'vk', uid: '123'))
          end

          it 'starts job to create user event' do
            expect(Events::CreateUserEventJob).to have_been_enqueued
          end
        end

        context 'when user with such email exists' do
          before do
            response = { user_id: '123', access_token: 'aaa', email: 'maxim@mail.com' }
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

          context 'when user has no providers' do
            let!(:user) { create(:user, :with_admin_role, email: 'maxim@mail.com') }

            it 'authenticates with this user' do
              expect(user.sign_in_count).to eq(0)

              vk_code = Base64.strict_encode64('my_code')
              expect do
                post '/api/v1/auth/providers/vk', params: {
                  vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
                }
              end.to change { User.first.sign_in_count }.from(0).to(1)

              expect(response).to have_http_status(:ok)
            end

            it 'generates new possession token' do
              vk_code = Base64.strict_encode64('my_code')
              expect do
                post '/api/v1/auth/providers/vk', params: {
                  vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
                }
              end.to change { user.possession_tokens.count }.from(0).to(1)

              expect(response).to have_http_status(:ok)
            end

            it 'sends new confirmation mail' do
              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
              expect(response).to have_http_status(:ok)
            end

            it 'starts job to create user event' do
              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(response).to have_http_status(:ok)
              expect(Events::CreateUserEventJob).to have_been_enqueued
            end

            it 'changes user role' do
              expect(User.first.role_value).to eq(50)

              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(response).to have_http_status(:ok)
              expect(User.first.role_value).to eq(-30)
              expect(User.first.role_before_reconfirm_value).to eq(50)
            end

            it 'updates user providers' do
              expect(User.first.providers.count).to eq(0)

              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(response).to have_http_status(:ok)
              expect(User.first.providers.count).to eq(1)
              expect(User.first.providers).to include(Provider.find_by(name: 'vk', uid: '123'))
            end
          end

          context 'when user has another provider' do
            let!(:user) do
              user = create(:user, :with_admin_role, email: 'maxim@mail.com')
              user.providers.create!(name: 'github', uid: '67')
            end

            it 'changes user role' do
              expect(User.first.role_value).to eq(50)

              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(response).to have_http_status(:ok)
              expect(User.first.role_value).to eq(-30)
              expect(User.first.role_before_reconfirm_value).to eq(50)
            end

            it 'sends new confirmation mail' do
              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
              expect(response).to have_http_status(:ok)
            end

            it 'updates user providers' do
              expect(User.first.providers.count).to eq(1)

              vk_code = Base64.strict_encode64('my_code')
              post '/api/v1/auth/providers/vk', params: {
                vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
              }

              expect(response).to have_http_status(:ok)
              expect(User.first.providers.count).to eq(2)
              expect(User.first.providers).to include(
                Provider.find_by(name: 'github', uid: '67'),
                Provider.find_by(name: 'vk', uid: '123')
              )
            end
          end
        end

        context 'when VK user data is incorrect in Followy' do
          let(:user_response) do
            {
              response: [
                {
                  id: '123', screen_name: 'maxbarsukov', first_name: 'Max', last_name: 'Barsukov',
                  status: 'My status', about: 'My about', site: 'https://maxbarsukov.vercel.app',
                  country: { title: 'Russia' }, city: { title: 'RnD' }
                }.merge(data_restrict)
              ]
            }
          end

          before do
            response = { user_id: '123', access_token: 'aaa', email: 'max@mail.com' }
            allow_any_instance_of(VkAdapter).to(
              receive(:access_token).and_return(Response::Vk::AccessTokenResponse.new(response))
            )

            allow_any_instance_of(VkAdapter).to(
              receive(:user_get).and_return(Response::Vk::UserGetResponse.new(user_response))
            )

            vk_code = Base64.strict_encode64('my_code')
            post '/api/v1/auth/providers/vk', params: {
              vk_code:, vk_redirect_uri: 'http://localhost:5000/callback_vk'
            }
          end

          context 'when location is incorrect' do
            let(:data_restrict) { { country: { title: 'Russia' * 100 } } }

            it 'changes location' do
              expect(response).to have_http_status(:ok)
              expect(User.first.location).to eq(('Russia' * 100)[0...200])
            end
          end

          context 'when blog is incorrect' do
            let(:data_restrict) { { site: 'no site here' } }

            it 'changes blog' do
              expect(response).to have_http_status(:ok)
              expect(User.first.blog).to be_nil
            end
          end

          context 'when username is too long' do
            let(:data_restrict) { { screen_name: 'hel-loъ' * 10 } }

            it 'changes username' do
              expect(response).to have_http_status(:ok)
              expect(User.first.username).to eq(('hel_lo' * 10)[0...25])
            end
          end

          context 'when username is too short' do
            let(:data_restrict) { { screen_name: 'he' } }

            it 'changes username' do
              expect(response).to have_http_status(:ok)
              expect(User.first.username).to eq('hehehehehe')
            end
          end
        end
      end

      context 'when user has no email in vk' do
        context 'when new user does not pass own email' do
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
                email: 'max@mail.com',
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
