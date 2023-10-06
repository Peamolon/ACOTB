module Api
  module V1
    class InstitutionsController < ApplicationController
      before_action :authenticate_user!

      def index
        institutions = Institution.paginate(page: params[:page], per_page: 10)
        total_pages = institutions.total_pages

        render json: {
          institutions: institutions,
          total_pages: total_pages
        }
      end

      def institution_names
        render json: Institution.all.pluck(:id, :name)
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
