module Api
  module V1
    module Users
      class ResetPasswordsController < ApplicationController
        before_action :authenticate_user!
        def update
          user = current_user
          old_password = params[:old_password]

          if user.valid_password?(old_password)
            new_password = params[:new_password]
            User.update(password: new_password)
            render json: { message: 'Update password correctly'}
          else
            render json: { message: "Don't reset password, don't match" }, status: :unprocessable_entity
          end
        end

        def send_email

        end

      end
    end
  end
end