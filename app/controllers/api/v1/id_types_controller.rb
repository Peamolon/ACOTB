module Api
  module V1
    class IdTypesController < ApplicationController
      before_action :authenticate_user!

      def index
        @id_types = UserProfile::DOCUMENT_TYPES
        render json: @id_types
      end
    end
  end
end