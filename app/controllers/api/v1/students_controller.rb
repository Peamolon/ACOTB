module Api
  module V1
    class StudentsController < ApplicationController
      before_action :set_student, only: [:show, :update]

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
        render json: @student
      end

      private
      def set_student
        @student = Student.find(params[:id])
      end

      def student_params
        params.require(:student).permit(:user_profile_id, :semester, :id_number, :id_type)
      end

    end
  end
end

