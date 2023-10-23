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
        @unity = Unity.find(params[:id])

        if unity_params[:period].present?
          academic_period = @unity.subject.academic_periods.find_by(number: unity_params[:period])
          if academic_period.nil?
            render json: { error: 'No existe ese corte en la materia' }, status: 422
            return
          end
        else
          academic_period = @unity.academic_period
        end

        unity_params_copy = unity_params.except(:period)

        if @unity.update(unity_params_copy.merge(academic_period_id: academic_period.id))
          render json: @unity, status: :ok
        else
          render json: @unity.errors, status: :unprocessable_entity
        end
      end

      # POST /api/v1/unities
      def create
        subject_id = unity_params[:subject_id]
        subject = Subject.find(subject_id)
        unless unity_params[:period].present?
          render json: { error: 'Corte es necesario' }, status: 422
          return
        end
        academic_period = subject.academic_periods.find_by(number: unity_params[:period])

        if academic_period.nil?
          render json: { error: 'No existe ese corte en la materia' }, status: 422
          return
        end
        unity_params_copy = unity_params.except(:period)

        @unity = Unity.new(unity_params_copy.merge(academic_period_id: academic_period.id))
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

      def destroy
        if @unity.activities.present?
          render json: { error: 'Unity has active activities' }, status: 422
          return
        end
        if @unity.destroy
          render json: { message: 'Unity was destroyed' }, status: 200
        else
          render json: { error: 'Something went wrong' }, status: 422
        end
      end


      private

      def unity_params
        params.require(:unity).permit(:type, :name, :subject_id, :period)
      end

      def set_unity
        @unity = Unity.find(params[:id])
      end
    end
  end
end
