module Api
  module V1
    class RotationTypesController < ApplicationController
      before_action :set_rotation_type, only: [:update]

      def create
        @rotation_type = RotationType.new(rotation_type_params)

        if @rotation_type.save
          render json: @rotation_type, status: :created
        else
          render json: @rotation_type.errors, status: :unprocessable_entity
        end
      end

      def update
        if @rotation_type.update(rotation_type_params)
          render json: @rotation_type
        else
          render json: @rotation_type.errors, status: :unprocessable_entity
        end
      end

      private
      def set_rotation_type
        @rotation_type = RotationType.find(params[:id])
      end

      def rotation_type_params
        params.require(:rotation_type).permit(:description, :credits, :approved, :id_type)
      end
    end
  end
end