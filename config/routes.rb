Rails.application.routes.draw do
  devise_for :users, skip: :all, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root 'home#index'
      resources :users, only: %i[index show]

      devise_scope :user do
        post   '/login'            => 'users/sessions#create',       as: :user_session
        delete '/logout'           => 'users/sessions#destroy',      as: :destroy_user_session
        post   '/signup'           => 'users/registrations#create',  as: :user_registration
      end
    end
  end
end
