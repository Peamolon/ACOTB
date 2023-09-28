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
      resources :id_types, only: [:index]
      resources :institutions, only: [:index, :show, :create, :update, :destroy]
      resources :subjects, only: [:index, :show, :create, :update, :destroy]
      resources :students, only: [:index, :show, :update] do
        collection do
          get 'get_student_count'
          get 'top_students'
        end

        member do
          get 'get_general_score'
          get 'get_activities'
          get 'get_subjects'
          get 'get_activities_count'
          get 'get_next_activity'
          get 'get_general_score'
          get 'get_subject_scores'
        end
      end

      resources :activities do
        collection do
          get 'in_progress'
          get 'closest_to_today'
        end
      end

      resources :academic_periods do
        collection do
          get 'get_next_period'
        end
      end
      #resources :student_informations, only: [:index, :create,  :show, :update]
      resources :rubrics, only: [:index, :create, :show, :update, :destroy]
      resources :unities, only: [:index, :show] do
        member do
          get 'activities'
        end
      end
      resources :rotations, only:[:index, :create, :show, :update, :destroy] do
        collection do
          get 'active_rotations'
        end
      end
      resources :rubric_rotation_scores, only:[:create, :update, :destroy]
      resources :rotation_types, only:[:create, :update]
      resources :administrators, only: [:index, :show, :create, :update]
      resources :activity_califications, only: [:create]
      resources :professors, only: [:index, :show, :create, :update] do
        member do
          get 'unities'
          get 'students'
          get 'activities'
          get 'activities/:activity_id/activity_califications', to: 'professors#activity_califications'
        end
      end
      resources :managers, only: [:index, :show, :create, :update]
      resources :directors, only: [:index, :show, :create, :update]
      namespace :validations do
        get :validate_token, to: 'tokens#validate_token'
        get :log_out_current_user, to: 'tokens#log_out_current_user'
      end
      namespace :users do
        resource :reset_passwords, only:[:update]
      end

      namespace :public do
        resources :rubric_informations do
          collection do
            get 'levels'
            get 'get_verb'
          end
        end
      end
    end
  end
end
