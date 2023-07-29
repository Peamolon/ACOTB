module Api
  module V1
    module Validations
      class TokensController < ApplicationController
        def log_out_current_user
          if sign_out(current_user)
            render json: {
              message: 'current user signed out'
            }
          end
        end

        def validate_token
          if user_signed_in?
            render json: {
              message: 'Token is active',
              data: current_user
            }
          else
            render json: {
              error: 'Token has expired'
            }, status: 403
          end
        end
      end
    end
  end
end

