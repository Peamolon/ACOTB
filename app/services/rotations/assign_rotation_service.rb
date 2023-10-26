module Rotations
  class AssignRotationService
    def initialize(attributes = {})
      @student_id = attributes[:student_id]
      @subject_id = attributes[:subject_id]
      @institution_id = attributes[:institution_id]
      @start_date = attributes[:start_date]
      @end_date = attributes[:end_date]
      @activities_ids = attributes[:activities_ids]
      @errors = {}
    end

    def call
      add_error("time", "Ya tiene una rotacion activa en esa fecha") if has_active_rotation?
      add_error("student_id", "Estudiante no existe") unless Student.exists?(@student_id)
      add_error("subject_id", "Materia no existe") unless Subject.exists?(@subject_id)
      add_error("institution_id", "Ips no existe") unless Institution.exists?(@institution_id)
      add_error("activities_ids", "Hay actividades que no pertenecen a la materia seleccionada") unless activities_are_valid?
      add_error("subject_id", "La materia no tiene un corte válido para las fechas de la rotación") unless Subject.find(@subject_id).academic_period_for_date(@start_date).present?

      if @errors.empty?
        rotation = create_rotation
        create_activity_califications(rotation)
        { success: true, message: 'Rotation creada con exito' }
      else
        { errors: @errors }
      end
    end

    private

    def add_error(field, message)
      @errors[field] = message
    end
    def has_active_rotation?
      existing_rotation = Rotation.where(student_id: @student_id)
                                  .where("(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?)",
                                         @start_date, @start_date, @end_date, @end_date)
                                  .exists?

      existing_rotation
    end

    def create_activity_califications(rotation)
      @activities_ids.each do |activity_id|
        activity = Activity.find(activity_id)
        activity_calification = ActivityCalification.create!(activity_id: activity_id, student_id: @student_id, rotation_id: rotation.id)
        bloom_levels = activity.bloom_taxonomy_levels
        bloom_levels.each do |bloom_level|
          BloomTaxonomyLevel.create(verb: bloom_level, level: BloomTaxonomyLevel::BLOOM_LEVELS[bloom_level], activity_calification_id: activity_calification.id)
        end
      end
    end

    def create_rotation
      subject = Subject.find(@subject_id)
      rotation = Rotation.create!(institution_id: @institution_id,
                       student_id: @student_id,
                       subject_id: @subject_id,
                       start_date: @start_date,
                       end_date: @end_date,
                       academic_period_id: subject.academic_period_for_date(@start_date).id)
      rotation
    end

    def period_is_valid?
      subject = Subject.find(@subject_id)
      academic_periods = subject.academic_periods

      academic_periods.select do |academic_period|
        if academic_period.start_date <= @end_date && academic_period.end_date >= @start_date
          return true
        end
      end

      return false
    end

    def activities_are_valid?
      activities = Activity.where(id: @activities_ids)
      if activities.pluck(:subject_id).uniq.size == 1
        if activities.first.subject_id == @subject_id
          return true
        end
      end
      return false
    end
  end

end