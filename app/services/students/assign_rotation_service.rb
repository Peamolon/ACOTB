module Students
  class AssignRotationService
    def initialize(student_id, subject_id, institution_id, start_date, end_date, activities_ids)
      @student_id = student_id
      @subject_id = subject_id
      @institution_id = institution_id
      @start_date = start_date
      @end_date = end_date
      @activities_ids = activities_ids
    end

    def call
      return { success: false, message: 'Estudiante no existe' } unless Student.exists?(@student_id)
      return { success: false, message: 'Materia no existe' } unless Subject.exists?(@subject_id)
      return { success: false, message: 'Ips no existe' } unless Institution.exists?(@institution_id)
      return { success: false, message: 'Hay actividades que no perteneces a la materia seleccionada' } unless activities_are_valid?
      return { success: false, message: 'Periodo de rotación no válido' } unless Subject.find(@subject_id).active_academic_period.present?

      rotation = create_rotation
      create_activity_califications(rotation)

      { success: true, message: 'Rotation created successfully' }
    end

    private

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
                       academic_period_id: subject.active_academic_period.id)
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
      if activities.pluck(:subject_id).size == 1
        if activities.first.subject_id == @subject_id
          return true
        end
      end
      return false
    end
  end

end