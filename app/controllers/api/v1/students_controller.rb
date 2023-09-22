module Api
  module V1
    class StudentsController < ApplicationController
      before_action :set_student, only: [:show, :update, :get_general_score, :get_activities, :get_subjects]
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

      def get_student_count
        render json: {
          'active_student_count': Student.count
        }
      end

      def get_subjects
        render json: @student.subjects.includes(:unities)
      end

      def get_activities
        render json: @student.activity_califications
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

