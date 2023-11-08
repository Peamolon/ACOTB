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
        @rotations = Rotation.all.joins(:institution).includes(activity_califications: [:activity]).order('created_at DESC').paginate(page: params[:page], per_page: 10)
        total_pages = @rotations.total_pages

        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date]) rescue nil
          end_date = Date.parse(params[:end_date]) rescue nil

          @rotations = @rotations.where("start_date >= ? AND end_date <= ?", start_date, end_date) if start_date && end_date
        end

        @rotations = @rotations.joins(student: :user_profile).where("LOWER(CONCAT(user_profiles.first_name, ' ', user_profiles.last_name)) LIKE ?", "%#{params[:name_student].downcase}%") if params[:name_student].present?
        @rotations = @rotations.where("LOWER(institutions.name) LIKE ?", "%#{params[:name_institution].downcase}%") if params[:name_institution].present?
        @rotations = @rotations.joins(:subject).where("LOWER(subjects.name) LIKE ?", "%#{params[:name_subject].downcase}%") if params[:name_subject].present?

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
        activities = @rotation.activity_califications.includes(:bloom_taxonomy_levels)

        render json: activities.as_json(include: :bloom_taxonomy_levels)
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