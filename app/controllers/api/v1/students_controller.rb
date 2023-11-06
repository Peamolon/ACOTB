require 'will_paginate/array'

module Api
  module V1
    class StudentsController < ApplicationController
      before_action :set_student, only: [:show, :update, :get_general_score,
                                         :get_activities, :get_subjects, :get_activities_count,
                                         :get_next_activity, :activity_calification, :get_general_score,
                                         :get_subject_scores, :get_unities, :activities, :rotations, :get_subjects_with_score,
                                         :get_rotation_info, :all_activities, :get_subjects_with_score_by_period]
      def index
        @students = Student.all.paginate(page: params[:page], per_page: 10)
        total_pages = @students.total_pages

        response_hash = {
          students: @students,
          total_pages: total_pages
        }

        render json: response_hash || []
      end

      def list
        @students = Student.all
        render json: @students
      end

      def update
        if @student.update(student_params)
          render json: @student
        else
          render json: @student.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @student, include: { user_profile: {} }
      end

      def get_general_score
        @score = @student.average_bloom_taxonomy_percentage
        render json: @score
      end

      def get_activities_count
        @pending_activities = @student.activity_califications.where(state: :no_grade).count
        @complete_activities = @student.activity_califications.where(state: :graded).count
        render json: {
          pending_activities_count: @pending_activities,
          complete_activities_count: @complete_activities
        }
      end

      def get_student_count
        render json: {
          'active_student_count': Student.count
        }
      end

      def get_subjects
        render json: @student.subjects.includes(:unities)
      end

      def get_next_activity
        render json: []
      end

      def get_subject_scores
        result = ActivityCalifications::CalculateBloomTaxonomyAverageBySubjectService.student_evolutions(17, 71)

        render json: result
      end

      def rotations
        rotations = @student.rotations.order(start_date: :desc).paginate(page: params[:page], per_page: 10)

        total_pages = rotations.total_pages

        response_hash = {
          rotations: rotations,
          total_pages: total_pages
        }

        render json: response_hash || []
      end

      def get_subjects_with_score_by_period
        professor_id = params[:professor_id]
        subject_id = params[:rotation_id]
        institution_id = params[:institution_id]

        subjects = @student.subjects.uniq

        subjects = subjects.where(professor_id: professor_id) if professor_id.present?

        subjects = subjects.where(id: subject_id) if subject_id.present?

        #subjects = subjects.joins(:institution).where("institutions.id" => institution_id) if institution_id.present?

        subjects = subjects.paginate(page: params[:page], per_page: 1)

        total_pages = subjects.total_pages

        response_hash = subjects.map do |subject|
          bloom_data = ActivityCalifications::CalculateBloomTaxonomyAverageBySubjectAndPeriodService.student_evolutions(@student.id, subject.id)
          {
            subject: subject,
            bloom_data: bloom_data
          }
        end

        render json: { subjects: response_hash, total_pages: total_pages } || { subjects: [], total_pages: 0 }
      end

      def get_subjects_with_score
        professor_id = params[:professor_id]
        subject_id = params[:rotation_id]
        institution_id = params[:institution_id]

        subjects = @student.subjects.uniq

        subjects = subjects.where(professor_id: professor_id) if professor_id.present?

        subjects = subjects.where(id: subject_id) if subject_id.present?

        #subjects = subjects.joins(:institution).where("institutions.id" => institution_id) if institution_id.present?

        subjects = subjects.paginate(page: params[:page], per_page: 3)

        total_pages = subjects.total_pages

        response_hash = subjects.map do |subject|
          bloom_data = ActivityCalifications::CalculateBloomTaxonomyAverageBySubjectService.student_evolutions(@student.id, subject.id)
          {
            subject: subject,
            bloom_data: bloom_data
          }
        end

        render json: { subjects: response_hash, total_pages: total_pages } || { subjects: [], total_pages: 0 }
      end



      def get_unities
        #unities_id = @student.subjects.joins(:unities).pluck('unities.id')
        unities = Unity.all.paginate(page: params[:page], per_page: 10)

        total_pages = unities.total_pages

        response_hash = {
          unities: unities,
          total_pages: total_pages
        }

        render json: response_hash || []
      end

      def activities
        per_page = params[:per_page] || 10
        activity_califications = ActivityCalification.where(student_id: @student.id).includes(:bloom_taxonomy_levels).paginate(page: params[:page], per_page: per_page)

        total_pages = activity_califications.total_pages
        render json: {
          activities: activity_califications.as_json(include: :bloom_taxonomy_levels),
          total_pages: total_pages
        }
      end

      def all_activities
        activity_califications = ActivityCalification.where(student_id: @student.id).includes(:rotation).includes(:bloom_taxonomy_levels)

        render json: activity_califications.as_json(
          include:{
            rotation: {
              methods: [:manager_name, :institution_name]
            },
            bloom_taxonomy_levels: {  }
          }
        )
      end

      def get_activities
        @activity_califications = @student.activity_califications.includes(:activity)
        activity_califications_by_unity = @activity_califications.group_by { |calification| calification.unity }
        render json: activity_califications_by_unity, methods: [:unity_name, :unity_type]
      end

      def get_general_score
        result = ::ActivityCalifications::CalculateBloomTaxonomyAverageService.new(@student.activity_califications).call
        render json: result
      end

      def get_rotation_info
        today = Date.today
        current_rotation = @student.rotations.where("start_date <= ? AND end_date >= ?", today, today).order(:start_date).first
        next_rotation = @student.rotations.where("start_date > ?", today).order(:start_date).first

        render json: {
          current_rotation: current_rotation,
          next_rotation: next_rotation
        }
      end


      def top_students
        @top_students = Student.joins(:activity_califications)
                               .group('students.id')
                               .order('AVG(activity_califications.numeric_grade) DESC')
                               .limit(5)
        render json: @top_students
      end

      def show_with_rubrics_and_average_bloom_taxonomy
        rubrics = @subject.rubrics
        activities = @subject.activities.includes(:activity_califications)

        average_bloom_taxonomy = calculate_average_bloom_taxonomy(activities)

        render json: {
          subject: @subject,
          rubrics: rubrics,
          average_bloom_taxonomy: average_bloom_taxonomy
        }
      end

      private
      def set_student
        @student = Student.find(params[:id])
      end

      def student_params
        params.require(:student).permit(:user_profile_id, :semester)
      end

    end
  end
end

