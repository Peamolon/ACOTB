module Api
  module V1
    class InstitutionsController < ApplicationController
      def index
        institutions = Institution.paginate(page: params[:page], per_page: 10)
        total_pages = institutions.total_pages

        render json: {
          institutions: institutions,
          total_pages: total_pages
        }
      end

      def list
        render json: Institution.all
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

      def update
        institution = Institution.find(params[:id])
        if institution.update(institution_params)
          render json: { message: 'Institución actualizada correctamente', data: institution }, status: :ok
        else
          render json: { errors: institution.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        institution = Institution.find(params[:id])
        if institution.rotations.present?
          render json: { errors: 'La institucion tiene rotaciones activas' }, status: :unprocessable_entity
          return
        end

        if institution.destroy
          render json: { message: 'Institución eliminada correctamente' }, status: :ok
        else
          render json: { errors: 'No se pudo eliminar la institución' }, status: :unprocessable_entity
        end
      end

      private

      def institution_params
        params.require(:institution).permit(:manager_id, :name, :code, :contact_email, :contact_telephone)
      end
    end
  end
end
