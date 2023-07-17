module Api
  module V1
    class StudentInformationsController < ApplicationController
      before_action :set_student_information, only: [:show, :update]

      def index
        @student_informations = StudentInformation.all

        render json: @student_informations
      end

      def create
        @student_information = StudentInformation.new(student_information_params)

        if @student_information.save
          render json: @student_information, status: :created
        else
          render json: @student_information.errors, status: :unprocessable_entity
        end
      end

      def update
        if @student_information.update(student_information_params)
          render json: @student_information
        else
          render json: @student_information.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @student_information
      end

      private
      def set_student_information
        @student_information = StudentInformation.find(params[:id])
        @student = @student_information.student
        @rubric = @student_information.rubric
      end

      def student_information_params
        params.require(:student_information).permit(:rotation_id, :student_id, :start_at, :end_at)
      end

    end
  end
end