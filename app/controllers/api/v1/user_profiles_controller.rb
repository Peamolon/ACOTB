module Api
  module V1
    class UserProfilesController < ApplicationController
      #before_action :authenticate_user!, except: :create
      before_action :set_user_profile, only: [:show, :update]
      def index
        user_profiles = UserProfile.all.order(updated_at: :desc)

        user_profiles = user_profiles.joins(:user).where("users.username ILIKE ?", "%#{params[:username]}%") if params[:username].present?
        user_profiles = user_profiles.joins(:user).where("users.email ILIKE ?", "%#{params[:email]}%") if params[:email].present?

        user_profiles = user_profiles.where("LOWER(CONCAT(first_name, ' ', last_name)) LIKE ?", "%#{params[:user_name].downcase}%") if params[:user_name].present?
        user_profiles = user_profiles.where("id_number ILIKE ?", "%#{params[:id_number]}%") if params[:id_number].present?
        user_profiles = user_profiles.where("username ILIKE ?", "%#{params[:username]}%") if params[:username].present?
        user_profiles = user_profiles.joins(:roles).where("roles.name ILIKE ?", "%#{params[:role]}%") if params[:role].present?
        user_profiles = user_profiles.where("email ILIKE ?", "%#{params[:email]}%") if params[:email].present?

        user_profiles = user_profiles.paginate(page: params[:page], per_page: 10)
        total_pages = user_profiles.total_pages

        response_hash = {
          user_profiles: user_profiles,
          total_pages: total_pages
        }

        render json: response_hash || []
      end


      def show
        render json: @user_profile, methods: [:email, :username, :assigned_roles]
      end

      def create
        user_profile_creator = ::Users::UserProfileCreatorService.new(create_user_profile_params)
        if user_profile_creator.valid?
          result = user_profile_creator.call
          if result.errors.any?
            render json: { errors: user_profile_creator.errors }, status: 400
          else
            render json: {
              message: 'UserProfile successfully created',
              data: result.user_profile.as_json(
                include: {
                  user: { only: [:email, :username] },
                  roles: { only: [:name] }
                }
              )
            }, status: :created
          end
        else
          render json: { errors: user_profile_creator.errors.full_messages }, status: 400
        end
      end

      def destroy
        destroy_user_service = ::Users::DestroyUserService.new(id: params[:id])
        if destroy_user_service.present?
          result = destroy_user_service.call
          if result.errors.any?
            render json: { errors: destroy_user_service.errors.full_messages }, status: 400
          else
            render json: {message: 'User was successfully destroyed'}, status: 200
          end
        else
          render json: { errors: 'User not found' }, status: 400
        end
      end

      def destroy_multiple_users
        user_ids = params[:user_ids]
        if user_ids.present?
          ActiveRecord::Base.transaction do
            user_ids.each do |user_id|
              destroy_user_service = ::Users::DestroyUserService.new(id: user_id)
              destroy_user_service.call
            end
            render json: { message: 'Users were successfully destroyed' }, status: 200
          end
        else
          render json: { errors: 'No user IDs provided' }, status: :unprocessable_entity
        end
      end

      def update
        if @user_profile.update(user_profile_params)
          render json: @user_profile, methods: [:email, :username, :assigned_roles]
        else
          render json: { errors: @user_profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user_profile
        @user_profile = UserProfile.find(params[:id])
      end

      def create_user_profile_params
        params.require(:user_profile).permit(:first_name, :last_name, :telephone, :role, :email, :username, :id_number, :id_type, :joined_at)
      end

      def user_profile_params
        params.require(:user_profile).permit(:first_name, :last_name, :telephone, :id_number, :id_type)
      end

      def destroy_multiple_params
        params.permit(user_ids: [])
      end
    end
  end
end

