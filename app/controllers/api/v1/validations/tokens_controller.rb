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
          render json: {
            message: 'Token is valid',
            data: {
              user: current_user.user_profile,
              role: current_user.user_profile.roles.last.name
            }
          }, status: :ok
        end
      end
    end
  end
end

