module Api
  module V1
    class ProfessorsController < ApplicationController
      before_action :set_professor, only: [:show, :update, :unities, :get_general_score, :students, :activities, :activity_califications]
      #before_action :authenticate_user!

      def index

      end

      def professor_count
        @professors = Professor.all
        render json: {
          professor_count: @professors.count
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