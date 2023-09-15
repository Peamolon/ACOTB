module Api
  module V1
    class AcademicPeriodsController < ApplicationController
      def get_next_period
        render json: AcademicPeriod.closest_to_today.end_date
      end
    end
  end
end