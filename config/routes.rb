Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'
      resources :users, only: %i[index show]

      post 'auth/sign_up' => 'auth#sign_up'
      post 'auth/sign_in' => 'auth#sign_in'
      delete 'auth/sign_out' => 'auth#sign_out'

      get '/health_check', to: ->(_env) { [200, {}, ['ok']] }
    end
  end
end
