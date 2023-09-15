module Api
  module V1
    class UnitiesController < ApplicationController
      before_action :set_unity, only: [:show, :edit, :update, :destroy]

      # GET /api/v1/unities
      def index
        @unities = Unity.all
        render json: @unities
      end

      # GET /api/v1/unities/1
      def show
        render json: @unity
      end

      # POST /api/v1/unities
      def create
        @unity = Unity.new(unity_params)
        if @unity.save
          render json: @unity, status: :created
        else
          render json: @unity.errors, status: :unprocessable_entity
        end
      end

      def activities
        @unity = Unity.find(params[:id])
        render json: 'Unity not found ' unless @unity.present?

        @activities = @unity.activities
        render json: @activities
      end

      private

      def set_unity
        @unity = Unity.find(params[:id])
      end
    end
  end
end
