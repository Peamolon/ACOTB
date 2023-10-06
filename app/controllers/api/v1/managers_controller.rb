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

      def students
        @students_ids = @manager.subjects.map(&:students).flatten.pluck(:id)
        @students = Student.where(id: @students_ids).paginate(page: params[:page], per_page: 10)

        total_pages = @students.total_pages

        response_hash = {
          students: @students,
          total_pages: total_pages
        }

        render json: response_hash
      end

      def activities
        @unities_ids = @manager.unities.pluck(:id)
        @activities = Activity.where(unity_id: @unities_ids).includes(:unity).paginate(page: params[:page], per_page: 10)

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

      def set_manager
        @manager = Manager.find(params[:id])
      end

      def manager_params
        params.require(:manager).permit(:user_profile_id, :position)
      end
    end
  end
end
