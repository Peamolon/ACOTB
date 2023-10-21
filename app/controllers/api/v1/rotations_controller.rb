module Api
  module V1
    class RotationsController < ApplicationController
      before_action :set_rotation, only: [:show, :update, :destroy, :subjects, :students]

      def show
        render json: @rotation
      end

      def destroy
        delete_rotation_service = ::Rotations::DeleteRotationService.new(rotation_id: @rotation.id)

        result = delete_rotation_service.call

        if result[:success]
          render json: { message: "Rotación eliminada exitosamente" }, status: :ok
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def create
        rotation_service = ::Rotations::AssignRotationService.new(rotation_params)

        result = rotation_service.call

        if result[:success]
          render json: result, status: :created
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def active_rotations
        render json: {
          'active_rotation_count': Rotation.active.count
        }
      end

      def update
        rotation_service = ::Rotations::EditRotationService.new(rotation_params.merge(rotation_id: params[:id]))

        result = rotation_service.call

        if result[:success]
          render json: result
        else
          render json: result, status: :unprocessable_entity
        end
      end


      def index
        @rotations = Rotation.all.includes(activity_califications: [:activity]).order('created_at DESC').paginate(page: params[:page], per_page: 10)
        total_pages = @rotations.total_pages

        render json: {
          rotations: @rotations.as_json(
            include: {
              activity_califications: {
                methods: [:activity_name, :unity_name]
              }
            },
            methods: [:institution_name, :manager_name]
          ),
          total_pages: total_pages
        }
      end

      def subjects
        @subjects = @rotation.subjects.paginate(page: params[:page], per_page: 10)
        total_pages = @subjects.total_pages

        render json: {
          subjects: @subjects,
          total_pages: total_pages
        }
      end

      def rotation_names
        render json: Rotation.all.pluck(:id, :name)
      end

      def students
        @students = @rotation.students.paginate(page: params[:page], per_page: 10)
        total_pages = @students.total_pages

        render json: {
          students: @students,
          total_pages: total_pages
        }
      end

      private
      def set_rotation
        @rotation = Rotation.find(params[:id])
      end

      def rotation_params
        params.require(:rotation).permit(
          :student_id,
          :subject_id,
          :institution_id,
          :start_date,
          :end_date,
          activities_ids: []
        )
      end

    end
  end
end