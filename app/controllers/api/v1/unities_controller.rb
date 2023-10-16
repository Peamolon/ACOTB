module Api
  module V1
    class UnitiesController < ApplicationController
      before_action :set_unity, only: [:show, :edit, :update, :destroy]

      # GET /api/v1/unities
      def index
        @unities = Unity.all.paginate(page: params[:page], per_page: 10)
        total_pages = @unities.total_pages
        render json: {
          unities: @unities,
          total_pages: total_pages
        }
      end

      # GET /api/v1/unities/1
      def show
        render json: @unity
      end

      def update
        if @unity.update(unity_params)
          render json: @unity
        else
          render json: @unity.errors, status: :unprocessable_entity
        end
      end

      # POST /api/v1/unities
      def create
        subject_id = unity_params[:subject_id]
        subject = Subject.find(subject_id)
        puts 'esta entrando aqui'
        current_academic_period = subject.active_academic_period

        if current_academic_period.nil?
          render json: { error: 'No active period for today' }, status: 422
          return
        end

        @unity = Unity.new(unity_params.merge(academic_period_id: current_academic_period.id))
        if @unity.save
          render json: @unity, status: :created
        else
          render json: @unity.errors, status: :unprocessable_entity
        end
      end

      def activities
        @unity = Unity.find(params[:id])

        unless @unity.present?
          render json: { error: 'Unity not found' }, status: :not_found
          return
        end

        per_page = params[:per_page] || 10
        @activities = @unity.activities.paginate(page: params[:page], per_page: per_page)
        total_pages = @activities.total_pages

        render json: {
          activities: @activities,
          total_pages: total_pages
        }
      end


      private

      def unity_params
        params.require(:unity).permit(:type, :name, :subject_id)
      end

      def set_unity
        @unity = Unity.find(params[:id])
      end
    end
  end
end
