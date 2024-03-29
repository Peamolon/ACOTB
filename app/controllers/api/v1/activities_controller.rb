module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :set_activity, only: [:show, :update, :destroy, :activity_califications]

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
        create_activity_service = Activities::CreateActivityService.new(create_activity_params)

        result = create_activity_service.call
        if result.errors.any?
          render json: { errors: create_activity_service.errors.full_messages }, status: 422
        else
          render json: {message: 'Actividad creada con exito', activity: result}, status: 200
        end

      end

      # PATCH/PUT /api/v1/activities/1
      def update
        edit_activity_service = Activities::EditActivityService.new(@activity.id, update_activity_params)

        result = edit_activity_service.call
        if result.errors.any?
          render json: { errors: edit_activity_service.errors.full_messages }, status: 422
        else
          render json: {message: 'Actividad editada con exito', activity: result}, status: 200
        end
      end

      def activity_types
        render json: Activity::ACTIVITY_TYPES
      end

      def activity_califications
        @activity_califications = @activity.activity_califications.includes(:bloom_taxonomy_levels).paginate(page: params[:page], per_page: 10)

        total_pages = @activity_califications.total_pages

        render json: {
          activity_califications: @activity_califications.as_json(include: :bloom_taxonomy_levels),
          total_pages: total_pages
        }
      end

      # DELETE /api/v1/activities/1
      def destroy
        delete_activity_service = ::Activities::DeleteActivityService.new(@activity.id)
        deleted_activity = delete_activity_service.call

        unless deleted_activity.errors.any?
          render json: { message: 'Activity was successfully deleted' }, status: 200
        else
          render json: { errors: delete_activity_service.errors.full_messages }, status: 422
        end
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

      def activity_params
        params.require(:activity).permit(:name, :type, :delivery_date)
      end

      def update_activity_params
        params.require(:activity).permit(:name, :type, bloom_levels: [])
      end

      def create_activity_params
        params.require(:activity).permit(
          :name,
          :type,
          :unity_id,
          :rotation_id,
          bloom_levels: []
        )
      end
    end
  end
end
