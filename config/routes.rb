Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'
      resources :users, only: %i[index show]

      get '/health_check', to: -> (env) { [200, {}, ['ok']] }
    end
  end
end
