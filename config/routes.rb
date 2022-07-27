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

  root to: redirect('/docs')

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'

      get 'users/search', to: 'users#search'

      resources :users, only: %i[index show update] do
        get 'posts', on: :member

        get 'roles', on: :member, to: 'users#roles'
        post 'roles', on: :member, to: 'users#add_role'
        put 'roles', on: :member, to: 'users#update_role'
        patch 'roles', on: :member, to: 'users#update_role'
        delete 'roles', on: :member, to: 'users#remove_role'

        get 'comments', on: :member

        get 'following', on: :member, to: 'users#following'
        get 'following/users', on: :member, to: 'users#following_users'
        get 'following/tags', on: :member, to: 'users#following_tags'

        get 'followers', on: :member
      end

      get 'tags/search'

      resources :tags, only: %i[index show] do
        get 'posts', on: :member
        get 'followers', on: :member
      end

      get 'posts/search'
      get 'posts/:id/comments/search', to: 'posts#search_comments'

      resources :posts do
        get 'comments', on: :member
        get 'tags', on: :member
      end

      get 'feed', to: 'posts#feed', as: :feed

      resources :comments, only: %i[show create update destroy]

      resources :versions, only: %i[index create show update destroy],
                           constraints: { id: /(?:(\d+)\.)?(?:(\d+)\.)?(\d+)/ }

      post 'votes/like', to: 'votes#like'
      delete 'votes/like', to: 'votes#unlike'
      post 'votes/dislike', to: 'votes#dislike'
      delete 'votes/dislike', to: 'votes#undislike'

      post 'follows', to: 'follows#follow'
      delete 'follows', to: 'follows#unfollow'

      namespace :auth do
        post 'sign_up'
        post 'sign_in'
        delete 'sign_out'
        get 'refresh'
        get 'confirm'
        get 'resend_confirm'
        post 'reset_password'
        post 'request_password_reset'
      end

      post '/auth/providers/github', to: 'auth#github_auth'
      post '/auth/providers/vk', to: 'auth#vk_auth'

      get '/health_check', to: ->(_env) { [200, {}, ['ok']] }
    end
  end
end
