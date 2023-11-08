require 'csv'

module Api
  module V1
    class CsvController < ApplicationController

      def create_user_batch
        uploaded_file = params[:csvFile]
        if uploaded_file
          csv_data = uploaded_file.read

          parsed_csv = CSV.parse(csv_data, col_sep: ';', headers: true)

          if parsed_csv
            success_data = []
            error_data = []
            parsed_csv.each do |row|

              user_params = {
                first_name: row['first_name'],
                last_name: row['last_name'],
                telephone: row['telephone'],
                email: row['email'],
                role: row['role'],
                username: row['username'],
                id_number: row['id_number'],
                id_type: row['id_type']
              }

              service = ::Users::UserProfileCreatorService.new(user_params)
              result = service.call

              if result.errors.present?
                error_data << row.to_h.merge(errors: result.errors.full_messages.join(','))
              else
                success_data << row.to_h.merge(creado: 'Si')
              end
            end

            combined_data = success_data + error_data

            send_data generate_csv(combined_data), filename: 'created_users_with_errors.csv'
          else
            render json: { error: 'No se pudo analizar el archivo CSV' }, status: :bad_request
          end
        else
          render json: { error: 'No se proporcionó un archivo CSV' }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def activity_califications_for_student
        student_id = params[:student_id]
        subject_id = params[:subject_id]

        state_map = {
          'graded' => 'Calificado',
          'no_grade' => 'No calificado'
        }

        type_map = {
          'THEORETICAL' => 'Teorica',
          'PRACTICAL' => 'Practica',
          'THEORETICAL_PRACTICAL' => 'Teorica-practica'
        }

        activity_califications = ActivityCalification.joins(activity: [ :unity, { unity: :academic_period } ])
                                                     .where(student_id: student_id, activities: { subject_id: subject_id })
                                                     .order('academic_periods.number')

        csv_data = CSV.generate(headers: true) do |csv|
          csv << [
            'Corte',
            'Nombre de la Actividad',
            'Tipo de Actividad',
            'Unidad',
            'Nota',
            'Fecha de Calificación',
            'Estado',
            'Nombre de la Materia',
            'Inicio de la Rotación',
            'Fin de la Rotación'
          ]

          activity_califications.each do |calification|
            activity = calification.activity
            unity = activity.unity
            academic_period = unity.academic_period
            subject = activity.subject
            rotation = calification.rotation
            translated_state = state_map[calification.state] || calification.state
            translated_type = type_map[activity.type] || activity.type

            csv << [
              academic_period.number,
              activity.name,
              translated_type,
              unity.name,
              calification.numeric_grade,
              calification.calification_date,
              translated_state,
              subject.name,
              rotation.start_date,
              rotation.end_date
            ]
          end
        end

        student = Student.find(student_id)
        subject = Subject.find(subject_id)

        send_data csv_data, filename: "#{student.full_name}_calificaciones_#{subject.name}.csv"
      end

      def all_activity_califications_for_student
        student_id = params[:student_id]

        state_map = {
          'graded' => 'Calificado',
          'no_grade' => 'No calificado'
        }

        type_map = {
          'THEORETICAL' => 'Teórica',
          'PRACTICAL' => 'Práctica',
          'THEORETICAL_PRACTICAL' => 'Teórica-Práctica'
        }

        activity_califications = ActivityCalification.joins(activity: [ :unity, { unity: :academic_period }, :subject ])
                                                     .where(student_id: student_id)
                                                     .order('academic_periods.number', 'subjects.name')

        csv_data = CSV.generate(headers: true) do |csv|
          csv << [
            'Nombre de la Materia',
            'Corte',
            'Nombre de la Actividad',
            'Tipo de Actividad',
            'Unidad',
            'Nota',
            'Fecha de Calificación',
            'Estado'
          ]

          activity_califications.each do |calification|
            activity = calification.activity
            unity = activity.unity
            academic_period = unity.academic_period
            subject = activity.subject
            translated_state = state_map[calification.state] || calification.state
            translated_type = type_map[activity.type] || activity.type

            csv << [
              subject.name,
              academic_period.number,
              activity.name,
              translated_type,
              unity.name,
              calification.numeric_grade,
              calification.calification_date,
              translated_state
            ]
          end
        end

        student = Student.find(student_id)

        send_data csv_data, filename: "#{student.full_name}_calificaciones_todas_materias.csv"
      end




      def create_rotations
        uploaded_file = params[:csvFile]
        if uploaded_file
          csv_data = uploaded_file.read

          parsed_csv = CSV.parse(csv_data, col_sep: ';', headers: true)

          if parsed_csv
            parsed_csv.each do |row|
              name = row['name']
              start_date = row['start_date']
              end_date = row['end_date']
              manager_email = row['manager_email']
              institution_name = row['institution']

              manager = Manager.joins(user_profile: :user).find_by("users.email = ?", manager_email)
              institution = Institution.find_by("name = ?", institution_name)

              if manager.nil?
                raise StandardError.new("Manager not found for email: #{row['manager_email']}")
              end

              if institution.nil?
                raise StandardError.new("Institution not found for name: #{row['institution']}")
              end

              rotation = Rotation.create(
                name: name,
                start_date: start_date,
                end_date: end_date,
                manager: manager,
                institution: institution
              )
            end

            render json: { message: 'Archivo CSV recibido y procesado exitosamente' }, status: :ok
          else
            render json: { error: 'No se pudo analizar el archivo CSV' }, status: :bad_request
          end
        else
          render json: { error: 'No se proporcionó un archivo CSV' }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def generate_csv(data)
        CSV.generate(headers: true) do |csv|
          csv << data.first.keys
          data.each do |row|
            csv << row.values
          end
        end
      end
    end
  end
end
