module Api
  module V1
    class UserProfilesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user_profile, only: [:show, :update]

      def index
        user_profiles = UserProfile.all
        render json: user_profiles
      end

      def show
        render json: @user_profile
      end

      def create
        user_profile = UserProfile.new(user_profile_params.merge(user_id: current_user.id, joined_at: Time.now))
        if user_profile.save
          render json: {message: 'UserProfile successfully created',data: user_profile}, status: :created
        else
          render json: { errors: user_profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user_profile.update(user_profile_params)
          render json: @user_profile
        else
          render json: { errors: @user_profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user_profile
        @user_profile = UserProfile.find(params[:id])
      end

      def user_profile_params
        params.require(:user_profile).permit(:first_name, :last_name, :telephone, :joined_at, :photoURL, :timezone, :settings)
      end
    end
  end
end

