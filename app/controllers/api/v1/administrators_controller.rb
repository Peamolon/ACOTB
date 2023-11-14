module Api
  module V1
    class AdministratorsController < ApplicationController
      before_action :set_administrator, only: [:show, :update]

      def index
        @administrators = Administrator.all
        render json: @administrators
      end

      def show
        render json: @administrator
      end

      def create
        @administrator = Administrator.new(administrator_params)

        if @administrator.save
          render json: @administrator, status: :created
        else
          render json: @administrator.errors, status: :unprocessable_entity
        end
      end

      def update
        if @administrator.update(administrator_params)
          render json: @administrator
        else
          render json: @administrator.errors, status: :unprocessable_entity
        end
      end

      def get_admin_counts
        active_rotations = Rotation.count
        active_students = Student.count
        active_professors = Professor.count
        active_subjects = Subject.count
        render json: {
          active_rotations: active_rotations,
          active_students: active_students,
          active_professors: active_professors,
          active_subjects: active_subjects
        }
      end

      def bloom_verbs
        stats = Activity.bloom_taxonomy_statistics
        render json: stats
      end

      def bloom_verbs_count
        counts = Activity.bloom_taxonomy_counts
        render json: counts
      end

      private

      def set_administrator
        @administrator = Administrator.find(params[:id])
      end

      def administrator_params
        params.require(:administrator).permit(:user_profile_id)
      end
    end
  end
end