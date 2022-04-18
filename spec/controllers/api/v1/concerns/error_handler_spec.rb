require 'rails_helper'

RSpec.describe Api::V1::Concerns::ErrorHandler, type: :controller do
  controller(Api::V1::ApiController) do
    def bad_request
      raise JSON::ParserError
    end

    def pundit_unauthorized
      raise Pundit::NotAuthorizedError, 'message'
    end

    def undefined_role_type
      raise Roles::UndefinedRoleTypeError
    end
  end

  before do
    routes.draw do
      get 'bad_request' => 'api/v1/api#bad_request', as: :bad_request
      get 'pundit_unauthorized' => 'api/v1/api#pundit_unauthorized', as: :pundit_unauthorized
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

  describe '#render_undefined_role_type' do
    it 'renders error' do
      get :undefined_role_type
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors'][0]['title']).to include('Undefined role type')
    end
  end
end
