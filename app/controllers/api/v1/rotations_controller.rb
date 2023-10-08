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

      def active_rotations
        render json: {
          'active_rotation_count': Rotation.active.count
        }
      end

      def update
        if @rotation.update(rotation_params)
          render json: @rotation
        else
          render json: @rotation.errors, status: :unprocessable_entity
        end
      end

      def index
        @rotations = Rotation.all.order('created_at DESC').paginate(page: params[:page], per_page: 10)
        total_pages = @rotations.total_pages

        render json: {
          rotations: @rotations.as_json(methods: [:institution_name, :manager_name]),
          total_pages: total_pages
        }
      end



      private
      def set_rotation
        @rotation = Rotation.find(params[:id])
      end

      def rotation_params
        params.require(:rotation).permit(:name, :start_date, :end_date, :rotation_type_id, :manager_id, :institution_id)
      end

    end
  end
end