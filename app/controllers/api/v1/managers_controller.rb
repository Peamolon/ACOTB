module Api
  module V1
    class ManagersController < ApplicationController
      before_action :set_manager, only: [:show, :update, :unities, :students,
                                         :activities, :activity_califications, :pending_activities,
                                         :get_manager_count, :get_next_activities, :get_rotations_with_subjects,
                                         :rotations_with_activities]

      def index
        @managers = Manager.all
        render json: @managers
      end

      def show
        render json: @manager
      end

      def calificate
        service = ::Activities::CalificateActivityService.new(calificate_params)
        result = service.call
        if result.errors.any?
          render json: { errors: result.errors.full_messages }, status: 422
        else
          render json: {message: 'actividad calificada'}, data: result, status: 200
        end
      end

      def edit_calification
        service = ::ActivityCalifications::EditActivityCalificationService.new(edit_calificate_params)
        result = service.call
        if result.errors.any?
          render json: { errors: result.errors.full_messages }, status: 422
        else
          render json: {message: 'Actividad editada', data: result.activity_calification.as_json(except: :rubrics)}, status: 200
        end
      end

      def pending_activities
        pending_activities = @manager.activities.where(state: :pending).limit(10)
        render json: pending_activities
      end


      def rotations_with_activities
        rotations = @manager.rotations.includes(activity_califications: :bloom_taxonomy_levels)
                            .next_and_past_week_rotations.order(start_date: :asc)
                            .paginate(page: params[:page], per_page: 10)
        total_pages = rotations.total_pages

        response_hash = {
          rotations: rotations.as_json(
            include: {
              activity_califications: {
                include: :bloom_taxonomy_levels,
                methods: [:activity_name]
              },
            }
          ),
          total_pages: total_pages
        }

        render json: response_hash || []
      end

      def get_rotations_with_subjects
        rotations = @manager.rotations.includes(:subjects).paginate(page: params[:page], per_page: 10)
        total_pages = rotations.total_pages

        response_hash = {
          rotations: rotations.as_json(include: :subjects),
          total_pages: total_pages
        }

        render json: response_hash
      end

      def get_manager_names
        managers = Manager.all
        manager_names = managers.map { |manager| [manager.id, manager.full_name] }
        render json: manager_names
      end

      def unities
        @manager_unities = @manager.unities.includes(:activities).order(:type).paginate(page: params[:page], per_page: 10)

        total_pages = @manager_unities.total_pages

        response_hash = {
          manager_unities: @manager_unities,
          total_pages: total_pages
        }

        render json: response_hash.to_json(:include => :activities)
      end

      def get_manager_count
        subjects = @manager.subjects

        rotations = @manager.rotations

        activities = Activity.where(subject: subjects)

        no_calification_count = activities.joins(:activity_califications)
                                          .where(activity_califications: {state: :no_grade}).count

        calification_count = activities.joins(:activity_califications)
                                       .where(activity_califications: {state: :grade}).count

        student_count = Student.joins(:rotations).where(rotations: {id: rotations.pluck(:id)}).count

        render json: {
          no_calification_count: no_calification_count,
          calification_count: calification_count,
          student_count: student_count
        }
      end

      def get_next_activities
        activities = @manager.activities.where("delivery_date >= ?", Date.today).order(:delivery_date).limit(10)
        render json: activities
      end

      def students
        @students = Student.includes(rotations: :institution).where(institutions: { manager_id: @manager.id }).paginate(page: params[:page], per_page: 10)

        total_pages = @students.total_pages

        students_with_rotations = @students.map do |student|
          {
            id: student.id,
            name: student.full_name,
            telephone: student.telephone,
            id_number: student.id_number,
            id_type: student.id_type,
            rotations: student.rotations.includes(:institution).where(institutions: { manager_id: @manager.id })
          }
        end

        render json: {
          students: students_with_rotations,
          total_pages: total_pages
        }
      end



      def activities
        rotations_ids = @manager.rotations.pluck(:id)
        @activities = Activity.where(rotation_id: rotations_ids).includes(:unity).paginate(page: params[:page], per_page: 10)

        total_pages = @activities.total_pages

        response_hash = {
          activities: @activities,
          total_pages: total_pages
        }

        render json: response_hash.to_json(:include => :unity)
      end

      def activity_califications
        @unities_ids = @manager.unities.pluck(:id)
        @activity_califications = Activity.find(params[:activity_id]).activity_califications.includes(:student).paginate(page: params[:page], per_page: 10)

        total_pages = @activity_califications.total_pages

        render json: {
          activity_califications: @activity_califications,
          total_pages: total_pages
        }
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

      def calificate_params
        params.require(:calificate).permit(:activity_calification_id, percentages: {}, comments: {})
      end

      def edit_calificate_params
        params.require(:activity_calification).permit(:activity_calification_id, percentages: {}, comments: {})
      end

      def set_manager
        @manager = Manager.find(params[:id])
      end

      def manager_params
        params.require(:manager).permit(:user_profile_id, :position)
      end
    end
  end
end
