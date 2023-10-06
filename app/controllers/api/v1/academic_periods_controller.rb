module Api
  module V1
    class AcademicPeriodsController < ApplicationController
      def get_next_period
        closest_period = AcademicPeriod.closest_to_today

        if closest_period.present?
          render json: closest_period.end_date
        else
          render json: { error: "No se encontró ningún período académico cercano." }, status: :not_found
        end
      end
    end
  end
end