module Api
  module V1
    class SubjectsController < ApplicationController
      before_action :set_subject, only: [:show, :update, :destroy, :get_unities_by_subject, :activities]

      def index
        per_page = params[:per_page] || 10
        @subjects = Subject.all.paginate(page: params[:page], per_page: per_page)
        total_pages = @subjects.total_pages
        render json: {
          subjects: @subjects,
          total_pages: total_pages
        }
      end

      def get_unities_by_subject
        render json: @subject.unities
      end

      def activities
        per_page = params[:per_page] || 10
        @subjects = Subject.all.paginate(page: params[:page], per_page: per_page)
        total_pages = @subjects.total_pages
        render json: {
          subjects: @subjects,
          total_pages: total_pages
        }
      end

      def show
        render json: @subject, methods: [:get_rubrics]
      end

      def create
        create_subject_service = ::Subjects::CreateSubjectService.new(create_subject_params)
        if create_subject_service.valid?
          result = create_subject_service.call
          if result.errors.any?
            render json: { errors: create_subject_service.errors.full_messages }, status: 400
          else
            render json: {message: 'Subject was successfully created'}, status: 200
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
        @subject.destroy
        head :no_content
      end

      private

      def set_subject
        @subject = Subject.find(params[:id])
      end

      def subject_params
        params.require(:subject).permit(:credits, :name)
      end

      def create_subject_params
        params.require(:subject).permit(:director_id, :name, :credits, :rotation_id,:professor_id, academic_period_info: [:start_date, :end_date], rubric_info: [:verb, :description])
      end
    end
  end
end
