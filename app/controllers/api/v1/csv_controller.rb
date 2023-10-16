require 'csv'

module Api
  module V1
    class CsvController < ApplicationController

      def create_rotations
        if params[:csvFile].present?
          file = params[:csvFile].tempfile
          csv_options = { col_sep: ';' }

          puts file

          CSV.foreach(file, csv_options) do |row|
            puts row
          end

        end
      end

    end
  end
end


