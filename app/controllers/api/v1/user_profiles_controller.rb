module Api
  module V1
    class UserProfilesController < ApplicationController
      #before_action :authenticate_user!, except: :create
      before_action :set_user_profile, only: [:show, :update]
      def index
        user_profiles = UserProfile.all.order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
        total_pages = user_profiles.total_pages

        response_hash = {
          user_profiles: user_profiles,
          total_pages: total_pages
        }

        render json: response_hash || []
      end

      def show
        render json: @user_profile, methods: [:email, :username, :assigned_roles]
      end

      def create
        user_profile_creator = ::Users::UserProfileCreatorService.new(create_user_profile_params)
        if user_profile_creator.valid?
          result = user_profile_creator.call
          if result.errors.any?
            render json: { errors: user_profile_creator.errors }, status: 400
          else
            render json: {
              message: 'UserProfile successfully created',
              data: result.user_profile.as_json(
                include: {
                  user: { only: [:email, :username] },
                  roles: { only: [:name] }
                }
              )
            }, status: :created
          end
        else
          render json: { errors: user_profile_creator.errors.full_messages }, status: 400
        end
      end

      def destroy
        destroy_user_service = ::Users::DestroyUserService.new(id: params[:id])
        if destroy_user_service.present?
          result = destroy_user_service.call
          if result.errors.any?
            render json: { errors: destroy_user_service.errors.full_messages }, status: 400
          else
            render json: {message: 'User was successfully destroyed'}, status: 200
          end
        else
          render json: { errors: 'User not found' }, status: 400
        end
      end

      def destroy_multiple_users
        user_ids = params[:user_ids]
        if user_ids.present?
          ActiveRecord::Base.transaction do
            user_ids.each do |user_id|
              destroy_user_service = ::Users::DestroyUserService.new(id: user_id)
              destroy_user_service.call
            end
            render json: { message: 'Users were successfully destroyed' }, status: 200
          end
        else
          render json: { errors: 'No user IDs provided' }, status: :unprocessable_entity
        end
      end

      def update
        if @user_profile.update(user_profile_params)
          render json: @user_profile, methods: [:email, :username, :assigned_roles]
        else
          render json: { errors: @user_profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def create_backup
        100.times do
          user_params = {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            telephone: "3#{rand(11..20)}#{rand(0..9999999).to_s.rjust(7, '0')}",
            role: Role.allowed_roles.sample,
            email: Faker::Internet.email,
            username: Faker::Internet.username,
            id_number: Faker::IDNumber.valid,
            id_type: UserProfile::DOCUMENT_TYPES.sample,
            joined_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
          }

          service = ::Users::UserProfileCreatorService.new(user_params)
          service.call
        end

        #Creating Institutions
        30.times do
          institution_params = {
            name: Faker::Company.name,
            code: Faker::Alphanumeric.alpha(number: 6).upcase,
            contact_email: Faker::Internet.email,
            contact_telephone: Faker::PhoneNumber.cell_phone,
            manager_id: Manager.all.sample.id
          }

          Institution.create!(institution_params)
        end

        #Creating rotations
        20.times do
          rotation_params = {
            name: Faker::Company.name,
            start_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now),
            end_date: Faker::Date.between(from: 1.month.from_now, to: 3.months.from_now),
            institution_id: rand(1..Institution.count),
            director_id: rand(1..Director.count)
          }

          Rotation.create(rotation_params)
        end


        #Creating Subjects
        def create_random_subject
          subject_params = {
            name: Faker::Educator.subject,
            credits: Faker::Number.between(from: 1, to: 5) * 3,
            manager_id: rand(1..Manager.count),
            professor_id: rand(1..Professor.count),
            academic_period_info: [
              {
                start_date: Faker::Date.between(from: '2023-09-01', to: '2023-12-15'),
                end_date: Faker::Date.between(from: '2023-12-16', to: '2024-04-30')
              },
              {
                start_date: Faker::Date.between(from: '2024-09-01', to: '2024-12-15'),
                end_date: Faker::Date.between(from: '2024-12-16', to: '2025-04-30')
              }
            ],
            rubric_info: [
              {
                verb: 'Recordar',
                description: 'Recordar '+ Faker::Lorem.word
              },
              {
                verb: 'Comprender',
                description: 'Comprender '+ Faker::Lorem.sentence
              },
              {
                verb: 'Aplicar',
                description: 'Aplicar '+ Faker::Lorem.word
              },
              {
                verb: 'Analizar',
                description: 'Analizar '+ Faker::Lorem.word
              },
              {
                verb: 'Evaluar',
                description: 'Evaluar '+ Faker::Lorem.word
              },
              {
                verb: 'Crear',
                description: 'Crear '+ Faker::Lorem.word
              },
            ]
          }

          ::Subjects::CreateSubjectService.new(subject_params).call
        end

        100.times do
          create_random_subject
        end

        #Create Unities
        400.times do
          Unity.create!(
            name: Faker::Lorem.words(number: 3).join(' '),
            type: Unity::UNITY_TYPES.sample,
            academic_period_id: AcademicPeriod.all.sample.id,
            subject_id: Subject.all.sample.id,
            )
        end

        #Assing subjects to students
        def assign_subjects_to_students
          student_ids = Student.all.pluck(:id)
          subject_ids = Subject.all.pluck(:id)

          max_subjects_to_assign = 4

          student_ids.each do |student_id|
            num_subjects_to_assign = rand(1..max_subjects_to_assign)

            subjects_to_assign = subject_ids.sample(num_subjects_to_assign)

            ::Students::AssignSubjectService.new(subjects_to_assign, [student_id]).call
          end
        end

        5.times do
          assign_subjects_to_students
        end

        #Create activities
        100.times do
          Activity.create!(
            name: Faker::Lorem.sentence(word_count: 16),
            type: Activity::ACTIVITY_TYPES.sample,
            delivery_date: Faker::Date.between(from: Date.today, to: Date.today + 30.days),
            unity_id: Unity.pluck(:id).sample,
            state: Activity.aasm.states.map(&:name).sample
          )
        end


        def generate_bloom_taxonomy_percentage
          total_percentage = 100
          levels = [1, 2, 3, 4, 5, 6]
          percentages = {}

          levels.each do |level|
            percentage = rand(0..total_percentage)
            percentages[level] = percentage
            total_percentage -= percentage
          end

          percentages
        end


        ActivityCalification.all.each do |calification|
          calification.update(
            numeric_grade: rand(0.0..5.0),
            notes: Faker::Lorem.sentence,
            calification_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
            bloom_taxonomy_percentage: generate_bloom_taxonomy_percentage
          )
        end
      end

      private

      def set_user_profile
        @user_profile = UserProfile.find(params[:id])
      end

      def create_user_profile_params
        params.require(:user_profile).permit(:first_name, :last_name, :telephone, :role, :email, :username, :id_number, :id_type, :joined_at)
      end

      def user_profile_params
        params.require(:user_profile).permit(:first_name, :last_name, :telephone)
      end

      def destroy_multiple_params
        params.permit(user_ids: [])
      end
    end
  end
end

