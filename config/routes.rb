Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  namespace :api do
    namespace :v1 do
      resources :user_profiles, only: [:index, :show, :create, :update, :destroy] do
        collection do
          delete :destroy_multiple_users
        end
      end
      resources :roles, only: [:index]
      resources :institutions, only: [:index, :show, :create, :update, :destroy]
      resources :subjects, only: [:index, :show, :create, :update, :destroy]
      resources :students, only: [:index, :show, :update]
      #resources :student_informations, only: [:index, :create,  :show, :update]
      resources :rubrics, only: [:index, :create, :show, :update, :destroy]
      resources :rotations, only:[:index, :create, :show, :update, :destroy]
      resources :rubric_rotation_scores, only:[:create, :update, :destroy]
      resources :rotation_types, only:[:create, :update]
      resources :administrators, only: [:index, :show, :create, :update]
      resources :professors, only: [:index, :show, :create, :update]
      resources :managers, only: [:index, :show, :create, :update]
      resources :directors, only: [:index, :show, :create, :update]
      namespace :validations do
        get :validate_token, to: 'tokens#validate_token'
        get :log_out_current_user, to: 'tokens#log_out_current_user'
      end
    end
  end
end
