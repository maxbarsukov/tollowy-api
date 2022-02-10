Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'
      resources :users, only: %i[index show]

      get '/health_check', to: ->(_env) { [200, {}, ['ok']] }
    end
  end
end
