require 'csv'

module Api
  module V1
    class CsvController < ApplicationController

      def create_rotations
        uploaded_file = params[:csvFile]
        if uploaded_file
          csv_data = uploaded_file.read

          parsed_csv = CSV.parse(csv_data, col_sep: ';', headers: true)

          if parsed_csv
            parsed_csv.each do |row|
              name = row['name']
              start_date = row['start_date']
              end_date = row['end_date']
              manager_email = row['manager_email']
              institution_name = row['institution']

              manager = Manager.joins(user_profile: :user).find_by("users.email = ?", manager_email)
              institution = Institution.find_by("name = ?", institution_name)

              if manager.nil?
                raise StandardError.new("Manager not found for email: #{row['manager_email']}")
              end

              if institution.nil?
                raise StandardError.new("Institution not found for name: #{row['institution']}")
              end

              rotation = Rotation.create(
                name: name,
                start_date: start_date,
                end_date: end_date,
                manager: manager,
                institution: institution
              )
            end

            render json: { message: 'Archivo CSV recibido y procesado exitosamente' }, status: :ok
          else
            render json: { error: 'No se pudo analizar el archivo CSV' }, status: :bad_request
          end
        else
          render json: { error: 'No se proporcionó un archivo CSV' }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
