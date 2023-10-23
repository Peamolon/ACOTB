module Rotations
  class DeleteRotationService
    def initialize(rotation_id:)
      @rotation_id = rotation_id
    end

    def call
      rotation = Rotation.find_by(id: @rotation_id)

      unless rotation
        return { success: false, message: 'La rotación no existe o no pertenece al estudiante' }
      end

      ActiveRecord::Base.transaction do

        BloomTaxonomyLevel.where(activity_calification_id: ActivityCalification.where(rotation_id: @rotation_id).pluck(:id)).destroy_all

        ActivityCalification.where(rotation_id: @rotation_id).destroy_all

        rotation.destroy
      end

      { success: true, message: 'Rotación eliminada con exito' }
    end
  end
end
