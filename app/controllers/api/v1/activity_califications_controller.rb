module Api
  module V1
    class ActivityCalificationsController < ApplicationController
      def create
        create_activity_calification_service = ActivityCalifications::CreateActivityCalificationService.new(calification_params)

        if create_activity_calification_service.valid?
         create_activity_calification_service.call
          activity_calification = create_activity_calification_service.activity_calification
          render json: {
            message: 'Calification created',
            data: activity_calification.as_json
          }, status: :created
        else
          render json: { errors: create_activity_calification_service.errors }, status: 400
        end
      end

      private

      def calification_params
        params.require(:activity_calification).permit(
          :activity_id,
          :student_id,
          :numeric_grade,
          :notes,
          :calification_date,
          bloom_taxonomy_percentage: {}
        )
      end
    end
  end
end