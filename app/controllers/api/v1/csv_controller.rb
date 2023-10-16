module Api
  module V1
    class CsvController < ApplicationController
      def create_rotations
        if params[:csv_file].present?
          file = params[:csv_file].tempfile

          CSV.foreach(file, headers: true) do |row|
            #Rotation.create(name: row['name'], start_date: row['start_date'], end_date: row['end_date'])
          end

          render json: { message: 'Rotations were created' }, status: :created
        else
          render json: { error: 'Please, upload a csv file' }, status: :unprocessable_entity
        end
      end
    end
  end
end


