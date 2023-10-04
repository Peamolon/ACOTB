module Api
  module V1
    class StudentsController < ApplicationController
      before_action :set_student, only: [:show, :update, :get_general_score,
                                         :get_activities, :get_subjects, :get_activities_count,
                                         :get_next_activity, :activity_calification, :get_general_score,
                                         :get_subject_scores, :get_unities, :activities]
      def index
        @students = Student.all
        render json: @students
      end

      def update
        if @student.update(student_params)
          render json: @student
        else
          render json: @student.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @student, include: { user_profile: {} }
      end

      def get_general_score
        @score = @student.average_bloom_taxonomy_percentage
        render json: @score
      end

      def get_activities_count
        @pending_activities = @student.activity_califications.where(state: :no_grade).count
        @complete_activities = @student.activity_califications.where(state: :graded).count
        render json: {
          pending_activities_count: @pending_activities,
          complete_activities_count: @complete_activities
        }
      end

      def get_student_count
        render json: {
          'active_student_count': Student.count
        }
      end

      def get_subjects
        render json: @student.subjects.includes(:unities)
      end

      def get_next_activity
        @activity = @student.activities.where("delivery_date >= ?", Date.today).order(delivery_date: :asc).first
        render json: {
          'next_activity': @activity || []
        }
      end

      def get_subject_scores
        result = ::ActivityCalifications::CalculateBloomTaxonomyAverageBySubjectService.new(@student).call
        render json: result
      end

      def get_unities
        unities_id = @student.subjects.joins(:unities).pluck('unities.id')
        unities = Unity.where(id: unities_id).paginate(page: params[:page], per_page: 10)

        total_pages = unities.total_pages

        response_hash = {
          unities: unities,
          total_pages: total_pages
        }

        render json: response_hash || []
      end

      def activities
        activity_califications = ActivityCalification.where(student_id: @student.id)

        render json: activity_califications, methods: [:unity_id, :activity_name, :activity_type, :rubrics]

      end

      def get_activities
        @activity_califications = @student.activity_califications.includes(:activity)
        activity_califications_by_unity = @activity_califications.group_by { |calification| calification.unity }
        render json: activity_califications_by_unity, methods: [:unity_name, :unity_type]
      end

      def get_general_score
        result = ::ActivityCalifications::CalculateBloomTaxonomyAverageService.new(@student.activity_califications).call
        render json: result
      end


      def top_students
        @top_students = Student.joins(:activity_califications)
                               .group('students.id')
                               .order('AVG(activity_califications.numeric_grade) DESC')
                               .limit(5)
        render json: @top_students
      end

      def show_with_rubrics_and_average_bloom_taxonomy
        rubrics = @subject.rubrics
        activities = @subject.activities.includes(:activity_califications)

        average_bloom_taxonomy = calculate_average_bloom_taxonomy(activities)

        render json: {
          subject: @subject,
          rubrics: rubrics,
          average_bloom_taxonomy: average_bloom_taxonomy
        }
      end

      private
      def set_student
        @student = Student.find(params[:id])
      end

      def student_params
        params.require(:student).permit(:user_profile_id, :semester)
      end

    end
  end
end

