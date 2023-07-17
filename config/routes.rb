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
      resources :students, only: [:index, :show, :update]
      #resources :student_informations, only: [:index, :create,  :show, :update]
      resources :rubrics, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
