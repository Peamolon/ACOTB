module Api
  module V1
    class ManagersController < ApplicationController
      before_action :set_manager, only: [:show, :update]

      def index
        @managers = Manager.all
        render json: @managers
      end

      def show
        render json: @manager
      end

      def create
        @manager = Manager.new(manager_params)

        if @manager.save
          render json: @manager, status: :created
        else
          render json: @manager.errors, status: :unprocessable_entity
        end
      end

      def update
        if @manager.update(manager_params)
          render json: @manager
        else
          render json: @manager.errors, status: :unprocessable_entity
        end
      end

      private

      def set_manager
        @manager = Manager.find(params[:id])
      end

      def manager_params
        params.require(:manager).permit(:user_profile_id, :position)
      end
    end
  end
end
