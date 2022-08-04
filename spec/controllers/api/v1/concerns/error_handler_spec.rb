require 'rails_helper'

RSpec.describe Api::V1::Concerns::ErrorHandler, type: :controller do
  controller(Api::V1::ApiController) do
    def bad_request
      raise JSON::ParserError
    end

    def pundit_unauthorized
      raise Pundit::NotAuthorizedError, 'message'
    end

    def json_parsing_error
      Oj.load('bad-json')
    end

    def undefined_role_type
      raise Roles::UndefinedRoleTypeError
    end
  end

  before do
    routes.draw do
      get 'bad_request' => 'api/v1/api#bad_request', as: :bad_request
      get 'pundit_unauthorized' => 'api/v1/api#pundit_unauthorized', as: :pundit_unauthorized
      get 'json_parsing_error' => 'api/v1/api#json_parsing_error', as: :json_parsing_error
      get 'undefined_role_type' => 'api/v1/api#undefined_role_type', as: :undefined_role_type
    end
  end

  describe '#render_bad_request' do
    it 'renders error' do
      get :bad_request
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#render_unauthorized' do
    it 'renders error' do
      get :pundit_unauthorized
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors'][0]['title']).to eq('Unauthorized')
      expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to eq('message')
    end
  end

  describe '#json_parsing_error' do
    it 'renders error' do
      get :json_parsing_error
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors'][0]['title']).to eq('Unprocessable Entity')
      expect(JSON.parse(response.body)['errors'][0]['detail'][0]).to start_with(
        'unexpected character (after ) at line 1, column 1'
      )
    end
  end

  describe '#render_undefined_role_type' do
    it 'renders error' do
      get :undefined_role_type
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors'][0]['title']).to include('Undefined role type')
    end
  end
end
