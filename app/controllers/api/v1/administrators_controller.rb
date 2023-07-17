module Api
  module V1
    class AdministratorsController < ApplicationController
      before_action :set_administrator, only: [:show, :update]
      before_action :authenticate_user!

      def index
        @administrators = Administrator.all
        render json: @administrators
      end

      def show
        render json: @administrator
      end

      def create
        @administrator = Administrator.new(administrator_params)

        if @administrator.save
          render json: @administrator, status: :created
        else
          render json: @administrator.errors, status: :unprocessable_entity
        end
      end

      def update
        if @administrator.update(administrator_params)
          render json: @administrator
        else
          render json: @administrator.errors, status: :unprocessable_entity
        end
      end

      private

      def set_administrator
        @administrator = Administrator.find(params[:id])
      end

      def administrator_params
        params.require(:administrator).permit(:user_profile_id)
      end
    end
  end
end