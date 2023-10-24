module Rotations
  class EditRotationService
    def initialize(attributes = {})
      @attributes = attributes.except(:rotation_id)
      @rotation_id = attributes[:rotation_id]
      @student_id = attributes[:student_id]
      @subject_id = attributes[:subject_id]
      @institution_id = attributes[:institution_id]
      @start_date = attributes[:start_date]
      @end_date = attributes[:end_date]
      @activities_ids = attributes[:activities_ids]
      @errors = {}
    end

    def call
      rotation = Rotation.find(@rotation_id)

      add_error("rotation_id", "Rotación no encontrada") unless rotation
      add_error("institution_id", "Ips no existe") unless @institution_id.blank? || Institution.exists?(@institution_id)
      add_error("student_id", "Esta rotación no pertenece al estudiante") unless rotation.student_id == @student_id
      add_error("activities_ids", "Hay actividades que no pertenecen a la materia seleccionada") unless @activities_ids.blank? || activities_are_valid?
      add_error("rotation_id", "Ya tiene una rotación activa en esa fecha") if has_active_rotation?(rotation)

      if @errors.empty?
        update_activity_califications(rotation) if @activities_ids.present?
        rotation.update!(@attributes)
        { success: true, message: 'Rotación editada exitosamente' }
      else
        { errors: @errors }
      end
    end

    private

    def add_error(field, message)
      @errors[field] = message
    end

    def has_active_rotation?(rotation)
      existing_rotation = Rotation.where(student_id: @student_id)
                                  .where("(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?)",
                                         @start_date, @start_date, @end_date, @end_date)
                                  .where.not(id: rotation.id)
                                  .exists?

      existing_rotation
    end

    def update_activity_califications(rotation)
      ActivityCalification.where(rotation_id: rotation.id).destroy_all

      @activities_ids.each do |activity_id|
        activity = Activity.find(activity_id)
        activity_calification = ActivityCalification.create!(activity_id: activity_id, student_id: @student_id, rotation_id: rotation.id)
        bloom_levels = activity.bloom_taxonomy_levels
        bloom_levels.each do |bloom_level|
          BloomTaxonomyLevel.create(verb: bloom_level, level: BloomTaxonomyLevel::BLOOM_LEVELS[bloom_level], activity_calification_id: activity_calification.id)
        end
      end
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
