require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :controller do
  include_context 'with active admin routes'

  describe '#destroy' do
    it 'resets all sessions' do
      session[:a] = '1'
      session[:b] = '2'
      expect(session[:a]).to eq('1')
      delete :destroy
      expect(session[:a]).to be_nil
      expect(session[:b]).to be_nil
    end

    it 'redirects to admin_root' do
      delete :destroy
      expect(response).to redirect_to(admin_root_path)
    end
  end

  describe '#new' do
    let(:user) { create(:user, :with_admin_role) }

    it 'redirects if user signed in' do
      request.headers['Authorization'] = ApiHelper.authenticated_header(user: user)
      get :new
      expect(response).to redirect_to(admin_root_path)
    end

    it 'renders login page if not signed in' do
      expect(get(:new)).to render_template(:new)
    end
  end

  describe '#create' do
    let(:user) { create(:user, :with_known_data) }

    context 'with valid data' do
      subject(:req) { post :create, params: { session: { email: user.email, password: user.password } } }

      it 'authenticates and redirects' do
        req
        expect(session[:access_token]).not_to be_nil
      end

      it 'redirects to admin page' do
        req
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context 'with invalid data' do
      subject(:req) { post :create, params: { session: { email: "#{user.email}111", password: user.password } } }

      it 'not authenticates' do
        req
        expect(session[:access_token]).to be_nil
      end

      it 'redirects to login page' do
        expect(req).to render_template(:new)
      end
    end
  end
end
