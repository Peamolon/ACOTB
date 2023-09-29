module Api
  module V1
    class ManagersController < ApplicationController
      before_action :set_manager, only: [:show, :update, :unities, :students, :activities, :activity_califications]

      def index
        @managers = Manager.all
        render json: @managers
      end

      def show
        render json: @manager
      end

      def unities
        @manager_unities = @manager.unities.includes(:activities).order(:type)
        render json: @manager_unities.to_json(:include => :activities)
      end

      def students
        @students = @manager.subjects.map(&:students).flatten
        render json: @students
      end

      def activities
        @unities_ids = @manager.unities.pluck(:id)
        @activities = Activity.where(unity_id: @unities_ids).includes(:unity)
        render json: @activities.to_json(:include => :unity)
      end

      def activity_califications
        @unities_ids = @manager.unities.pluck(:id)
        @activity_califications = Activity.find(params[:activity_id]).activity_califications.includes(:student)

        render json: @activity_califications, methods: [:student_name]
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

      def set_manager
        @manager = Manager.find(params[:id])
      end

      def manager_params
        params.require(:manager).permit(:user_profile_id, :position)
      end
    end
  end
end
