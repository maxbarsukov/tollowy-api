require 'rails_helper'

RSpec.describe Api::V1::Concerns::Response, type: :controller do
  describe '#json_response' do
    controller(BaseController) do
      include ::Api::V1::Concerns::Response

      def index
        json_response({ a: 1 }, :not_found)
      end
    end

    it 'renders body and status' do
      get :index
      expect(response).to have_http_status(:not_found)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['a']).to eq 1
    end
  end

  describe '#json_error' do
    context 'when invalid error' do
      controller(BaseController) do
        include ::Api::V1::Concerns::Response

        def index
          json_error('Error')
        end
      end

      it 'raises error with undefined error type' do
        expect { get :index }.to raise_error(UndefinedErrorDataType)
      end
    end

    context 'with errors array' do
      controller(BaseController) do
        include ::Api::V1::Concerns::Response

        def index
          json_error([ErrorData.new(title: 'Error')])
        end
      end

      it 'raises error with undefined error type' do
        expect { get :index }.not_to raise_error
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
