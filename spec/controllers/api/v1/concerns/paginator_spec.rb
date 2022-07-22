require 'rails_helper'

RSpec.describe Api::V1::Concerns::Paginator, type: :controller do
  describe '#paginate' do
    controller(BaseController) do
      include ::Api::V1::Concerns::Paginator
      include ::Api::V1::Concerns::Response

      def index
        Post.reindex
        search = Post.pagy_search('hello')
        paginated = paginate(search, number: 1, size: 10, searchkick: true)
        json_response({ ok: paginated.pagy.page })
      end
    end

    it 'paginates with searchkick' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['ok']).to eq 1
    end
  end
end
