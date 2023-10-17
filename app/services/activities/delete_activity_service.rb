module Activities
  class DeleteActivityService
    include ActiveModel::Validations

    attr_accessor :activity_id

    def initialize(activity_id)
      @activity_id = activity_id
    end

    def call
      activity = Activity.find_by(id: activity_id)

      unless activity
        errors.add(:activity_id, 'Activity not found')
        return nil
      end

      ActiveRecord::Base.transaction do
        activity_califications = activity.activity_califications
        activity_califications.each{ |activity_calification| activity_calification.bloom_taxonomy_levels.destroy_all}
        activity_califications.destroy_all
        activity.destroy
      end

      activity
    end
  end
end
