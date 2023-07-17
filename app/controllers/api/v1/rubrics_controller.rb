module Api
  module V1
    class RubricsController < ApplicationController
      before_action :set_rubric, only: [:show, :update, :destroy]

      def index
        @rubrics = Rubric.all
        render json: @rubrics
      end

      def create
        @rubric = Rubric.new(rubric_params)

        if @rubric.save
          render json: @rubric, status: :created
        else
          render json: @rubric.errors, status: :unprocessable_entity
        end
      end

      def update
        if @rubric.update(rubric_params)
          render json: @rubric
        else
          render json: @rubric.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @rubric
      end

      def destroy
        @rubric.destroy
        head :no_content
      end

      private
      def set_rubric
        @rubric = Rubric.find(params[:id])
      end

      def rubric_params
        params.require(:rubric).permit(:name, :level, :response)
      end

    end
  end
end