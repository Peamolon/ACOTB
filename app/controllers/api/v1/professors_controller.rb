module Api
  module V1
    class ProfessorsController < ApplicationController
      before_action :set_professor, only: [:show, :update, :get_unities]
      #before_action :authenticate_user!

      def index
        @professors = Professor.all
        render json: @professors
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

      def get_unities
        render json: @professor.unities
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