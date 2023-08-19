module Api
  module V1
    class PasswordResetsController < ApplicationController
      before_action :authenticate_user!

      def respond_to_reset
        user = current_user
        mail =  UserMailer.reset_password(user).deliver_now
        if mail
          render json: { message: 'Send instructions for reset password' }
        else
          render json: { message: "Don't send instructions for reset password because don't exist this email" }, status: :unprocessable_entity
        end
      end

    end
  end
end

