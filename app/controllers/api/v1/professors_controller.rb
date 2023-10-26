module Api
  module V1
    class ProfessorsController < ApplicationController
      before_action :set_professor, only: [:show, :update,
                                           :unities, :get_general_score, :students_by_subject,
                                           :activities, :activity_califications,:get_professor_count,
                                           :get_closest_activities, :subjects]
      #before_action :authenticate_user!

      def index
        render json: Professor.all
      end

      def professor_count
        @professors = Professor.all
        render json: {
          professor_count: @professors.count
        }
      end

      def get_closest_activities
        recent_activities = @professor.activities.order(delivery_date: :desc).limit(10)
        render json: recent_activities, status: :ok
      end

      def subjects
        per_page = params[:per_page] || 10
        subjects = Subject.where(professor_id: @professor.id)

        if params[:name].present?
          subjects = subjects.where("name ILIKE ?", "%#{params[:name]}%")
        end

        if params[:created_at].present?
          subjects = subjects.where("created_at >= ?", params[:created_at])
        end

        if params[:rotation_id].present?
          subjects = subjects.where(rotation_id: params[:rotation_id])
        end

        @subjects = subjects.paginate(page: params[:page], per_page: per_page)
        total_pages = @subjects.total_pages

        render json: {
          subjects: @subjects,
          total_pages: total_pages
        }
      end

      def students_by_subject
        per_page = params[:per_page] || 10
        subjects = Subject.where(professor_id: @professor.id).paginate(page: params[:page], per_page: per_page)

        total_pages = subjects.total_pages

        subject_with_students = subjects.map do |subject|
          {
            id: subject.id,
            professor_name: subject.professor_name,
            name: subject.name,
            credits: subject.credits,
            students: Student.joins(:rotations).where(rotations: {subject_id: subject.id}).uniq
          }
        end

        render json: {
          subjects: subject_with_students,
          total_pages: total_pages
        }
      end


      def get_professor_count
        subjects = @professor.subjects.count

        student_count = Student.joins(subjects: :professor).where('professors.id' => @professor.id).distinct.count

        render json: {
          subjects_count: subjects,
          student_count: student_count
        }
      end
      def professor_names
        @professors = Professor.all
        professor_list = @professors.map { |professor| [professor.id, professor.full_name] }
        render json: professor_list
      end

      def show
        render json: @professor
      end

      def create
        @professor = Professor.new(professor_params)

        if @professor.save
          render json: @professor, status: :created
        else
          render json: @professor.errors, status: :unprocessable_entity
        end
      end

      def update
        if @professor.update(professor_params)
          render json: @professor
        else
          render json: @professor.errors, status: :unprocessable_entity
        end
      end

      def unities
        @professor_unities = @professor.unities.includes(:activities).order(:type)
        render json: @professor_unities.to_json(:include => :activities)
      end
      def activities
        @unities_ids = @professor.unities.pluck(:id)
        @activities = Activity.where(unity_id: @unities_ids).includes(:unity)
        render json: @activities.to_json(:include => :unity)
      end

      def activity_califications
        @unities_ids = @professor.unities.pluck(:id)
        @activity_califications = Activity.find(params[:activity_id]).activity_califications.includes(:student)

        render json: @activity_califications, methods: [:student_name]
      end

      def students
        @students = @professor.subjects.map(&:students).flatten
        render json: @students
      end


      private

      def set_professor
        @professor = Professor.find(params[:id])
      end

      def professor_params
        params.require(:professor).permit(:user_profile_id)
      end
    end
  end
end