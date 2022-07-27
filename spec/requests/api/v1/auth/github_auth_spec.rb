# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticate with GitHub', type: :request do
  describe 'POST github_auth' do
    context 'with new user' do
      context 'when Github request is valid' do
        before do
          user_response = {
            id: 12, login: 'maxbarsukov', bio: 'My bio', blog: 'maxbarsukov.vercel.app', location: 'A, B'
          }
          allow_any_instance_of(GithubAdapter).to(
            receive(:user).and_return(Response::Github::UserResponse.new(user_response))
          )
          user_emails_response = [{ email: 'maxbarsukov@bk.ru', verified: true, primary: true, visibility: true }]
          allow_any_instance_of(GithubAdapter).to(
            receive(:user_emails).and_return(Response::Github::UserEmailsResponse.new(user_emails_response))
          )
        end

        context 'when user with such email does not exists' do
          it 'creates new user' do
            expect(User.count).to eq(0)

            token = Base64.strict_encode64('github_token_stub')
            post '/api/v1/auth/providers/github', params: { token: }

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)['data']['meta']['message']).to eq(
              'You have successfully signed in with GitHub.'
            )
            expect(User.count).to eq(1)
          end

          it 'sets Github attributes to new user' do
            token = Base64.strict_encode64('github_token_stub')
            post '/api/v1/auth/providers/github', params: { token: }

            user = User.first
            expect(user).to have_attributes(
              username: 'maxbarsukov',
              role_value: 0,
              bio: 'My bio',
              blog: 'https://maxbarsukov.vercel.app',
              location: 'A, B'
            )
          end

          it 'adds Github provider to new user' do
            token = Base64.strict_encode64('github_token_stub')
            post '/api/v1/auth/providers/github', params: { token: }

            user = User.first
            expect(user.providers.count).to eq(1)
            expect(user.providers.first).to have_attributes(name: 'github', uid: '12')
          end

          it 'starts job to create user event' do
            token = Base64.strict_encode64('github_token_stub')
            post '/api/v1/auth/providers/github', params: { token: }

            expect(response).to have_http_status(:created)
            expect(Events::CreateUserEventJob).to have_been_enqueued
            expect(AuthMailer).not_to have_been_enqueued
          end
        end

        context 'when Github user data is incorrect in Followy' do
          context 'when location is incorrect' do
            before do
              user_response = { id: 12, login: 'max', bio: 'bio', blog: 'vercel.app', location: 'qqq' * 100 }
              allow_any_instance_of(GithubAdapter).to(
                receive(:user).and_return(Response::Github::UserResponse.new(user_response))
              )
            end

            it 'changes location' do
              expect(User.count).to eq(0)

              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:created)
              expect(JSON.parse(response.body)['data']['meta']['message']).to eq(
                'You have successfully signed in with GitHub.'
              )
              expect(User.first.location).to eq('q' * 200)
            end
          end

          context 'when blog is incorrect' do
            before do
              user_response = { id: 12, login: 'max', bio: 'bio', blog: 'vercel.app' * 100, location: 'qqq' }
              allow_any_instance_of(GithubAdapter).to(
                receive(:user).and_return(Response::Github::UserResponse.new(user_response))
              )
            end

            it 'returns error' do
              expect(User.count).to eq(0)

              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:unprocessable_entity)
              expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq(
                'Blog is too long (maximum is 200 characters)'
              )
            end
          end

          context 'when username is too long' do
            before do
              user_response = { id: 12, login: 'max-' * 10, bio: 'bio', blog: 'vercel.app', location: 'qqq' }
              allow_any_instance_of(GithubAdapter).to(
                receive(:user).and_return(Response::Github::UserResponse.new(user_response))
              )
            end

            it 'changes username' do
              expect(User.count).to eq(0)

              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:created)
              expect(User.first.username).to eq(('max_' * 10)[0...25])
            end
          end

          context 'when username is too short' do
            before do
              user_response = { id: 12, login: 'qq', bio: 'bio', blog: 'vercel.app', location: 'qqq' }
              allow_any_instance_of(GithubAdapter).to(
                receive(:user).and_return(Response::Github::UserResponse.new(user_response))
              )
            end

            it 'changes username' do
              expect(User.count).to eq(0)

              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:created)
              expect(User.first.username).to start_with('qq')
              expect(User.first.username.length).to eq(6)
            end
          end

          context 'when username already exists' do
            before do
              create(:user, :with_user_role, username: 'helloitsme')
              user_response = { id: 12, login: 'helloitsme', bio: 'bio', blog: 'vercel.app', location: 'qqq' }
              allow_any_instance_of(GithubAdapter).to(
                receive(:user).and_return(Response::Github::UserResponse.new(user_response))
              )
            end

            it 'adds random nums to username' do
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:created)
              expect(User.last.username).not_to eq('helloitsme')
              expect(User.last.username).to start_with('helloitsme')
              expect(User.last.username.length).to eq(12)
            end
          end
        end

        context 'when user with such email exists' do
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

          context 'when user has no providers' do
            let!(:user) do
              user = User.new(username: 'maxbarsukov', email: 'maxbarsukov@bk.ru', password: 'MyPassw1')
              user.save!
              user.role = :admin
              user
            end

            it 'authenticates with this user' do
              expect(user.sign_in_count).to eq(0)

              token = Base64.strict_encode64('github_token_stub')
              expect { post '/api/v1/auth/providers/github', params: { token: } }
                .to change { User.first.sign_in_count }.from(0).to(1)

              expect(response).to have_http_status(:ok)
              expect(JSON.parse(response.body)['data']['meta']['message']).to eq(
                'You have successfully logged in with GitHub. You were not previously authorized with this provider, ' \
                'but it has verified email (maxbarsukov@bk.ru) that belongs to maxbarsukov. ' \
                'For security purposes, you must verify this email to regain your role. ' \
                'Confirmation email has been sent to this email. ' \
                'Please follow the link in the email to verify your account. ' \
                'Until then you are authorized but unconfirmed.'
              )
            end

            it 'generates new possession token' do
              token = Base64.strict_encode64('github_token_stub')
              expect { post '/api/v1/auth/providers/github', params: { token: } }
                .to change { User.first.possession_tokens.count }.from(0).to(1)

              expect(response).to have_http_status(:ok)
            end

            it 'sends new confirmation mail' do
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
              expect(response).to have_http_status(:ok)
            end

            it 'starts job to create user event' do
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:ok)
              expect(Events::CreateUserEventJob).to have_been_enqueued
            end

            it 'changes user role' do
              expect(User.first.role_value).to eq(50)
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:ok)
              expect(User.first.role_value).to eq(-30)
              expect(User.first.role_before_reconfirm_value).to eq(50)
            end

            it 'updates user providers' do
              expect(User.first.providers).to be_empty
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:ok)
              expect(User.first.providers.count).to eq(1)
              expect(User.first.providers).to include(Provider.find_by(name: 'github', uid: '12'))
            end
          end

          context 'when user has another provider' do
            let!(:user) do
              user = User.new(username: 'maxbarsukov', email: 'maxbarsukov@bk.ru', password: 'MyPassw1')
              user.save!
              user.providers.create!(name: 'vk', uid: '123')
              user.role = :admin
              user
            end

            it 'changes user role' do
              expect(User.first.role_value).to eq(50)
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:ok)
              expect(User.first.role_value).to eq(-30)
              expect(User.first.role_before_reconfirm_value).to eq(50)
              expect(JSON.parse(response.body)['data']['meta']['message']).to eq(
                'You have successfully logged in with GitHub. You were not previously authorized with this provider, ' \
                'but it has verified email (maxbarsukov@bk.ru) that belongs to maxbarsukov. ' \
                'For security purposes, you must verify this email to regain your role. ' \
                'Confirmation email has been sent to this email. ' \
                'Please follow the link in the email to verify your account. ' \
                'Until then you are authorized but unconfirmed.'
              )
            end

            it 'sends new confirmation mail' do
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(ActionMailer::MailDeliveryJob).to have_been_enqueued
              expect(response).to have_http_status(:ok)
            end

            it 'updates user providers' do
              expect(User.first.providers.count).to eq(1)
              token = Base64.strict_encode64('github_token_stub')
              post '/api/v1/auth/providers/github', params: { token: }

              expect(response).to have_http_status(:ok)
              expect(User.first.providers.count).to eq(2)
              expect(User.first.providers).to include(Provider.find_by(name: 'github', uid: '12'))
            end
          end
        end
      end
    end

    context 'with existing user and provider' do
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

      it 'signs in as existing user' do
        user = User.new(username: 'maxbarsukov', email: 'maxbarsukov@bk.ru', password: 'MyPassw1')
        user.save!
        expect(user.sign_in_count).to eq(0)
        user.providers.create!(name: 'github', uid: '12')

        token = Base64.strict_encode64('github_token_stub')
        expect { post '/api/v1/auth/providers/github', params: { token: } }.not_to change(User, :count)
        expect do
          post '/api/v1/auth/providers/github', params: { token: }
        end.to change { User.first.sign_in_count }.from(1).to(2)

        expect(JSON.parse(response.body)['data']['meta']['message']).to eq(
          'You have successfully logged in with GitHub.'
        )
      end
    end

    context 'when Github request is invalid' do
      context 'when token encoding is bad' do
        it 'returns 422 status' do
          post '/api/v1/auth/providers/github', params: { token: 'bad_token' }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq("Can't decode GitHub token")
        end
      end

      context 'when access token is incorrect' do
        before do
          response = ResponseStub.new('401', JSON.generate({ message: 'My error' }))
          allow_any_instance_of(GithubAdapter).to(receive(:user).and_return(Response::Github::Error.new(response)))
        end

        it 'returns 424 status' do
          token = Base64.strict_encode64('github_token_stub')
          post '/api/v1/auth/providers/github', params: { token: }

          expect(response).to have_http_status(:failed_dependency)
          expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq(
            'Request to GitHub failed with status 401. Message: My error'
          )
        end
      end

      context 'when answer JSON is incorrect' do
        before do
          response = ResponseStub.new('400', 'haha, incorrect')
          allow_any_instance_of(GithubAdapter).to(receive(:user).and_return(Response::Github::Error.new(response)))
        end

        it 'returns 424 status' do
          token = Base64.strict_encode64('github_token_stub')
          post '/api/v1/auth/providers/github', params: { token: }

          expect(response).to have_http_status(:failed_dependency)
          expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq(
            'Request to GitHub failed with status 400. Body parsing failed'
          )
        end
      end

      context 'when Github timeout' do
        before do
          allow_any_instance_of(GithubAdapter).to(receive(:user).and_raise(Faraday::TimeoutError))
        end

        it 'returns 424 status' do
          token = Base64.strict_encode64('github_token_stub')
          post '/api/v1/auth/providers/github', params: { token: }

          expect(response).to have_http_status(:failed_dependency)
          expect(JSON.parse(response.body)['errors'][0]['title']).to eq('Timeout at dependent service')
        end
      end
    end
  end
end
