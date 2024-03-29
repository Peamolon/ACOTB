Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get 'recovery_password', to: 'passwords#recovery'
  end

  get '/health', to: 'application#health'
  namespace :api do
    namespace :v1 do
      resources :user_profiles, only: [:index, :show, :create, :update, :destroy] do
        collection do
          delete :destroy_multiple_users
          post 'create_backup'
        end
      end
      resources :csv do
        collection do
          post 'create_rotations'
          post 'create_user_batch'
          get 'activity_califications_for_student'
          get 'all_activity_califications_for_student'
        end
      end
      resources :roles, only: [:index]
      resources :id_types, only: [:index]
      resources :institutions, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'institution_names'
          get 'list'
        end
      end
      resources :subjects, only: [:index, :show, :create, :update, :destroy] do
        member do
          get 'unities', to: 'subjects#get_unities_by_subject'
          get 'activities'
          get 'get_activities'
          get 'graphics'
        end
        collection do
          get 'list'
          get 'subject_names'
        end
      end
      resources :students, only: [:index, :show, :update] do
        collection do
          get 'get_student_count'
          get 'top_students'
          get 'list'
        end

        member do
          get 'get_general_score'
          get 'get_activities'
          get 'get_subjects'
          get 'get_activities_count'
          get 'get_next_activity'
          get 'get_general_score'
          get 'get_subject_scores'
          get 'get_unities'
          get 'activities', to: 'students#activities'
          get 'rotations'
          get 'get_subjects_with_score'
          get 'all_activities'
          get 'get_rotation_info'
          get 'get_subjects_with_score_by_period'
          get 'califications'
        end
      end

      resources :activities do
        collection do
          get 'in_progress'
          get 'closest_to_today'
          get 'activity_types'
        end

        member do
          get 'activity_califications'
        end
      end

      resources :academic_periods do
        collection do
          get 'get_next_period'
        end
      end
      #resources :student_informations, only: [:index, :create,  :show, :update]
      resources :rubrics, only: [:index, :create, :show, :update, :destroy]
      resources :unities, only: [:index, :show, :create, :update, :destroy] do
        member do
          get 'activities'
        end
      end
      resources :rotations, only:[:index, :create, :show, :update, :destroy] do
        collection do
          get 'active_rotations'
          get 'rotation_names'
        end
        member do
          get 'subjects'
          get 'students'
          get 'activities'
        end
      end
      resources :rubric_rotation_scores, only:[:create, :update, :destroy]
      resources :rotation_types, only:[:create, :update]
      resources :administrators, only: [:index, :show, :create, :update] do
        collection do
          get 'get_admin_counts'
          get 'bloom_verbs'
          get 'bloom_verbs_count'
        end
      end
      resources :activity_califications, only: [:create] do
        member do
          get 'activity_califications'
        end
      end
      resources :professors, only: [:index, :show, :create, :update] do
        collection do
          get 'professor_count'
          get 'professor_names'
        end

        member do
          get 'get_professor_count'
          get 'get_closest_activities'
          get 'subjects'
          get 'students_by_subject'
        end
      end
      resources :managers, only: [:index, :show, :create, :update] do
        collection do
          get 'get_manager_names'
          post 'calificate'
          patch 'edit_calification'
        end
        member do
          get 'unities'
          get 'students'
          get 'activities'
          get 'activities/:activity_id/activity_califications', to: 'managers#activity_califications'
          get 'pending_activities'
          get 'get_manager_count'
          get 'get_next_activities'
          get 'get_rotations_with_subjects'
          get 'rotations_with_activities'
          get 'next_rotations'
        end
      end
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
