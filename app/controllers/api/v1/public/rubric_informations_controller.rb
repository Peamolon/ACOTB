module Api
  module V1
    module Public
      class RubricInformationsController < ApplicationController
        def levels
          @levels = Rubric::LEVELS
          render json: @levels
        end

        def get_verb
          @verb = params[:verb] || []
          render json: Rubric::keywords_for_verb(@verb)
        end
      end
    end
  end
end
