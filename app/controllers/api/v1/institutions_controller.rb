module Api
  module V1
    class InstitutionsController < ApplicationController
      #before_action :authenticate_user!

      def index
        institutions = Institution.all
        render json: institutions
      end

      def create
        institution = Institution.new(institution_params)
        if institution.save
          render json: {message: 'Institucion creada correctamente',data: institution}, status: :created
        else
          render json: { errors: institution.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def institution_params
        params.require(:institution).permit(:manager_id, :name, :code, :contact_email, :contact_telephone)
      end
    end
  end
end
