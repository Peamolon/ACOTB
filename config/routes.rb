Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  namespace :api do
    namespace :v1 do
      resources :user_profiles, only: [:index, :show, :create, :update, :destroy]
      resources :roles, only: [:index]
      resources :institutions, only: [:index, :show, :create, :update, :destroy]
      resources :subjects, only: [:index, :show, :create, :update, :destroy]
      resources :administrators, only: [:index, :show, :create, :update]
      resources :professors, only: [:index, :show, :create, :update]
    end
  end
end
