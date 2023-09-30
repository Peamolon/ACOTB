module Api
  module V1
    class StudentsController < ApplicationController
      before_action :set_student, only: [:show, :update, :get_general_score,
                                         :get_activities, :get_subjects, :get_activities_count,
                                         :get_next_activity, :activity_calification, :get_general_score,
                                         :get_subject_scores]
      def index
        @students = Student.paginate(page: params[:page], per_page: 10)
        total_pages = @students.total_pages

        render json: {
          students: @students,
          total_pages: total_pages
        }
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
        @subjects = @student.subjects.includes(:unities).paginate(page: params[:page], per_page: 10)
        total_pages = @subjects.total_pages

        render json: {
          subjects: @subjects,
          total_pages: total_pages
        }
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

      def get_activities
        @activities = @student.activity_califications.paginate(page: params[:page], per_page: 10)
        total_pages = @activities.total_pages

        render json: {
          activities: @activities,
          total_pages: total_pages
        }, methods: [:unity, :activity_name, :activity_type]
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

