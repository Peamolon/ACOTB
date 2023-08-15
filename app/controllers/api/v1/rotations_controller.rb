module Api
  module V1
    class RotationsController < ApplicationController
      before_action :set_rotation, only: [:show, :update, :destroy]

      def show
        render json: @rotation
      end

      def destroy
        @rotation.destroy
        head :no_content
      end

      def create
        @rotation = Rotation.new(rotation_params)
        if @rotation.save
          render json: @rotation, status: :created
        else
          render json: @rotation.errors, status: :unprocessable_entity
        end
      end

      def update
        if @rotation.update(rotation_params)
          render json: @rotation
        else
          render json: @rotation.errors, status: :unprocessable_entity
        end
      end

      def index
        @rotations = Rotation.all
        render json: @rotations
      end


      private
      def set_rotation
        @rotation = Rotation.find(params[:id])
      end

      def rotation_params
        params.require(:rotation).permit(:name, :start_date, :end_date, :rotation_type_id, :director_id, :institution_id)
      end

    end
  end
end