module Rotations
  class EditRotationService
    def initialize(attributes = {})
      @attributes = attributes.except(:rotation_id)
      @rotation_id = attributes[:rotation_id]
      @start_date = attributes[:start_date]
      @end_date = attributes[:end_date]
      @student_id = attributes[:student_id]
      @errors = {}
    end

    def call
      rotation = Rotation.find(@rotation_id)

      add_error("rotation_id", "Ya tiene una rotación activa en esa fecha") if has_active_rotation?(rotation)
      if @errors.empty?
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
  end
end
