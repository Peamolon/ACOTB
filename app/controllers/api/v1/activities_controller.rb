module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :set_activity, only: [:show, :update, :destroy]

      # GET /api/v1/activities
      def index
        @activities = Activity.all
        render json: @activities
      end

      # GET /api/v1/activities/1
      def show
        render json: @activity
      end

      # POST /api/v1/activities
      def create
        @activity = Activity.new(activity_params)

        if @activity.save
          render json: @activity, status: :created
        else
          render json: @activity.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/activities/1
      def update
        if @activity.update(activity_params)
          render json: @activity
        else
          render json: @activity.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/activities/1
      def destroy
        @activity.destroy
      end

      def closest_to_today
        @activities = Activity.where("delivery_date >= ?", Date.today).where(state: :pending).order(delivery_date: :asc).limit(5)

        render json: @activities, methods: [:days_until_delivery]
      end

      # GET /api/v1/activities/in_progress
      def in_progress
        @activities_in_progress = Activity.in_progress
        render json: {
          'active_activities_count': @activities_in_progress.count
        }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_activity
        @activity = Activity.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def activity_params
        params.require(:activity).permit(:name, :type, :state, :unity_id)
      end
    end
  end
end
