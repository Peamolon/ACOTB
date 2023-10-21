module Api
  module V1
    module Validations
      class TokensController < ApplicationController
        before_action :authenticate_user!, except: :log_out_current_user
        def log_out_current_user
          if sign_out(current_user)
            render json: {
              message: 'current user signed out'
            }
          end
        end

        def validate_token
          user_profile = current_user.user_profile
          data = {}

          data[:student_id] = user_profile.student.id if user_profile.student.present?
          data[:professor_id] = user_profile.professor.id if user_profile.professor.present?
          data[:manager_id] = user_profile.manager.id if user_profile.manager.present?


          render json: {
            message: 'Token is valid',
            data: {
              user: current_user.user_profile,
              role: current_user.user_profile.roles.last.name,
              entity: data,
            }
          }, status: :ok
        end
      end
    end
  end
end

