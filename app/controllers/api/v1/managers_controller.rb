module Api
  module V1
    class ManagersController < ApplicationController
      before_action :set_manager, only: [:show, :update, :unities, :students,
                                         :activities, :activity_califications, :pending_activities,
                                         :get_manager_count, :get_next_activities, :get_rotations_with_subjects,
                                         :rotations_with_activities, :next_rotations]

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
          render json: result.activity_calification.as_json(include: [:bloom_taxonomy_levels, :rotation]) , status: 200
        end
      end

      def edit_calification
        service = ::ActivityCalifications::EditActivityCalificationService.new(edit_calificate_params)
        result = service.call
        if result.errors.any?
          render json: { errors: result.errors.full_messages }, status: 422
        else
          render json: result.activity_calification.as_json(include: :bloom_taxonomy_levels), status: 200
        end
      end

      def pending_activities
        pending_activities = @manager.activities.where(state: :pending).limit(10)
        render json: pending_activities
      end

      def next_rotations
        rotations = @manager.rotations.includes(activity_califications: :bloom_taxonomy_levels, subject: :rubrics)
                            .next_and_past_week_rotations.order(start_date: :asc)
                            .joins(:activity_califications).where(activity_califications: {state: :no_grade})

        rotations = rotations.joins(student: :user_profile).where("LOWER(CONCAT(user_profiles.first_name, ' ', user_profiles.last_name)) LIKE ?", "%#{params[:student_name].downcase}%") if params[:student_name].present?

        rotations = rotations.joins(student: :user_profile).where("LOWER(user_profiles.id_number) LIKE ?", "%#{params[:id_number].downcase}%") if params[:id_number].present?

        rotations = rotations.paginate(page: params[:page], per_page: 10)
        total_pages = rotations.total_pages

        response_hash = {
          rotations: rotations.as_json(
            include: {

              subject: {
                include: :rubrics
              },
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


      def rotations_with_activities
        rotations = @manager.rotations.includes(activity_califications: :bloom_taxonomy_levels, subject: :rubrics)
                            .order(start_date: :asc)

        rotations = rotations.joins(student: :user_profile).where("LOWER(CONCAT(user_profiles.first_name, ' ', user_profiles.last_name)) LIKE ?", "%#{params[:student_name].downcase}%") if params[:student_name].present?

        rotations = rotations.joins(student: :user_profile).where("LOWER(user_profiles.id_number) LIKE ?", "%#{params[:id_number].downcase}%") if params[:id_number].present?

        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date]) rescue nil
          end_date = Date.parse(params[:end_date]) rescue nil

          rotations = rotations.where("start_date >= ? AND end_date <= ?", start_date, end_date) if start_date && end_date
        end

        rotations = rotations.paginate(page: params[:page], per_page: 10)
        #.next_and_past_week_rotations.order(start_date: :asc)
        total_pages = rotations.total_pages

        response_hash = {
          rotations: rotations.as_json(
            include: {

              subject: {
                include: :rubrics
              },
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
        activities = Activity.where(subject: subjects)
        activity_califications = ActivityCalification.where(activity: activities)
        no_graded_activities = activity_califications.where(state: :no_grade).count

        graded_activities = activity_califications.where(state: :graded).count

        render json: {
          no_graded_activities: no_graded_activities,
          graded_activities: graded_activities,
        }
      end

      def get_next_activities
        activities = @manager.activities.where("delivery_date >= ?", Date.today).order(:delivery_date).limit(10)
        render json: activities
      end

      def students
        @students = Student.includes(rotations: :institution).where(institutions: { manager_id: @manager.id }).paginate(page: params[:page], per_page: 10)

        @students = @students.joins(:user_profile).where("LOWER(CONCAT(user_profiles.first_name, ' ', user_profiles.last_name)) LIKE ?", "%#{params[:student_name].downcase}%") if params[:student_name].present?

        @students = @students.joins(:user_profile).where("LOWER(user_profiles.id_number) LIKE ?", "%#{params[:id_number].downcase}%") if params[:id_number].present?

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
        params.require(:calificate).permit(:numeric_grade, :activity_calification_id, percentages: {}, comments: {})
      end

      def edit_calificate_params
        params.require(:activity_calification).permit(:numeric_grade,:activity_calification_id, percentages: {}, comments: {})
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
