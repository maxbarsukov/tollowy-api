Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'

  mount Sidekiq::Web, at: '/sidekiq'

  ActiveAdmin.routes(self) unless Rails.env.test?

  namespace :admin do
    get 'sign_in', to: 'sessions#new'
    post 'sign_in', to: 'sessions#create', as: 'log_in'
    delete 'sign_out', to: 'sessions#destroy'
  end

  namespace :api, defaults: { format: 'json' } do # rubocop:disable Metrics/BlockLength
    namespace :v1 do
      root 'home#index'

      resources :users, only: %i[index show update] do
        get 'posts', on: :member
        get 'comments', on: :member
      end

      resources :posts do
        get 'comments', on: :member
      end

      resources :comments, only: %i[show create update destroy]

      post 'votes/like', to: 'votes#like'
      delete 'votes/like', to: 'votes#unlike'
      post 'votes/dislike', to: 'votes#dislike'
      delete 'votes/dislike', to: 'votes#undislike'

      post 'follow', to: 'follows#follow'
      delete 'follow', to: 'follows#unfollow'

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
