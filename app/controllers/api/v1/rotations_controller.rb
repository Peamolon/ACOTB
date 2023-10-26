module Api
  module V1
    class RotationsController < ApplicationController
      before_action :set_rotation, only: [:show, :update, :destroy, :subjects, :students, :activities]

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

        if result.is_a?(Rotation)
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
        rotations = Rotation.all.pluck(:id)

        mock_data = rotations.each_with_object([]) do |id, result|
          result << { id: id, name: 'Nombre Genérico' }  # Agregar un nombre genérico a cada id
        end

        render json: mock_data
      end

      def activities
        activities = @rotation.activities

        render json: activities
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
          :start_date,
          :end_date,
          :student_id,
          :subject_id,
          :institution_id,
          activities_ids: []
        )
      end

    end
  end
end