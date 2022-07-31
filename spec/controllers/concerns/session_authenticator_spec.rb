require 'rails_helper'

RSpec.describe SessionAuthenticator, type: :controller do
  controller(ApplicationController) do
    include SessionAuthenticator # rubocop:disable RSpec/DescribedClass

    def custom
      render json: { a: 1 }
    end

    def hello
      authenticate_admin_user!
    end
  end

  before do
    routes.draw do
      get 'custom' => 'anonymous#custom'
      get 'hello' => 'anonymous#hello'
      ActiveAdmin.routes(self)
      namespace :admin do
        get 'sign_in', to: 'sessions#new'
        post 'sign_in', to: 'sessions#create', as: 'log_in'
        delete 'sign_out', to: 'sessions#destroy'
      end
    end
  end

  describe '#set_authentication_header' do
    let(:user) { create(:user, :with_known_data) }

    it 'sets Authorization header' do
      session[:access_token] = ApiHelper.authenticated_header(user:)

      expect(request.headers['Authorization']).to be_nil
      get :custom
      expect(request.headers['Authorization']).to start_with('Bearer')
    end
  end

  describe '#authenticate_admin_user!' do
    it 'redirects if user dont signed in' do
      get :hello
      expect(response).to redirect_to(admin_sign_in_path)
    end

    it 'redirects if user not an admin' do
      user = create(:user, :with_known_data)
      request.headers['Authorization'] = ApiHelper.authenticated_header(user:)

      get :hello
      expect(response).to redirect_to(admin_sign_in_path)
    end
  end
end
