# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticate with VK', type: :request do
  describe 'POST vk_auth' do
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
          ResponseStub = Struct.new(:status, :body)
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
