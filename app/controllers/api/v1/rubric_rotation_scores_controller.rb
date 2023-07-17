module Api
  module V1
    class RubricRotationScoresController < ApplicationController
      before_action :set_rubric_rotation_score, only: [:update, :destroy]

      def create
        @rubric_rotation_score = RubricRotationScore.new(rubric_rotation_score_params)

        if @rubric_rotation_score.save
          render json: @rubric_rotation_score, status: :created
        else
          render json: @rubric_rotation_score.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @rubric_rotation_score.destroy
        head :no_content
      end

      def update
        if @rubric_rotation_score.update(set_rubric_rotation_score)
          render json: @rubric_rotation_score
        else
          render json: @rubric_rotation_score.errors, status: :unprocessable_entity
        end
      end

      private

      def set_rubric_rotation_score
        @rubric_rotation_score = RubricRotationScore.find(params[:id])
      end

      def rubric_rotation_score_params
        params.require(:rubric_rotation_score).permit(:rotation_id, :rubric_id, :score)
      end
    end
  end
end
