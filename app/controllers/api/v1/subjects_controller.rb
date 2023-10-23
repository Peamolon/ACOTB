module Api
  module V1
    class SubjectsController < ApplicationController
      before_action :set_subject, only: [:show, :update, :destroy, :get_unities_by_subject,
                                         :activities, :get_activities]

      def index
        per_page = params[:per_page] || 10
        @subjects = Subject.all.includes(:rubrics, :academic_periods).paginate(page: params[:page], per_page: per_page)
        total_pages = @subjects.total_pages
        render json: {
          subjects: @subjects.as_json(include: [:rubrics, :academic_periods]),
          total_pages: total_pages
        }
      end

      def list
        render json: Subject.all
      end

      def get_unities_by_subject
        render json: @subject.unities
      end

      def activities
        activities = @subject.activities
        render json: activities
      end

      def get_activities
        per_page = params[:per_page] || 10
        activities = @subject.activities.paginate(page: params[:page], per_page: per_page)
        total_pages = activities.total_pages
        render json: {
          activities: activities,
          total_pages: total_pages
        }
      end

      def show
        render json: @subject.to_json(include: [:rubrics, :academic_periods])
      end

      def create
        create_subject_service = ::Subjects::CreateSubjectService.new(create_subject_params)
        if create_subject_service.valid?
          result = create_subject_service.call
          if result.errors.any?
            render json: { errors: create_subject_service.errors.full_messages }, status: 400
          else
            render json: {message: 'Subject was successfully created', subject: result}, status: 200
          end
        else
          render json: { errors: create_subject_service.errors.full_messages }, status: 400
        end

      end

      def update
        if @subject.update(subject_params)
          render json: @subject
        else
          render json: @subject.errors, status: :unprocessable_entity
        end
      end

      def destroy
        delete_service = ::Subjects::DeleteSubjectService.new(subject: @subject)
        result = delete_service.call
        if result.errors.empty?
          render json: {message: 'Subject was successfully destroyed'}, status: 200
        else
          render json: { errors: delete_service.errors.full_messages }, status: 400
        end
      end

      private

      def set_subject
        @subject = Subject.find(params[:id])
      end

      def subject_params
        params.require(:subject).permit(:credits, :name, :professor_id)
      end

      def create_subject_params
        params.require(:subject).permit(:director_id, :name, :credits, :rotation_id,:professor_id, academic_period_info: [:start_date, :end_date], rubric_info: [:verb, :description])
      end
    end
  end
end
