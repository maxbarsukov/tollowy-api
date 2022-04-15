Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'

  mount Sidekiq::Web, at: '/sidekiq'

  ActiveAdmin.routes(self) unless Rails.env.test?

  namespace :admin do
    get 'sign_in', to: 'sessions#new'
    post 'sign_in', to: 'sessions#create', as: 'log_in'
    delete 'sign_out', to: 'sessions#destroy'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'
      resources :users, only: %i[index show update]
      resources :posts

      namespace :auth do
        post 'sign_up'
        post 'sign_in'
        delete 'sign_out'
        get 'confirm'
        post 'reset_password'
        post 'request_password_reset'
      end

      get '/health_check', to: ->(_env) { [200, {}, ['ok']] }
    end
  end
end
