Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'

  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'
      resources :users, only: %i[index show update]

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
