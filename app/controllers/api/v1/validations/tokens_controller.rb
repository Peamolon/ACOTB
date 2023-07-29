module Api
  module V1
    module Validations
      class TokensController < ApplicationController
        def log_out_current_user
          sign_out(current_user)
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
            }, status: :unauthorized
          end
        end
      end
    end
  end
end

