module Activities
  class CalificateActivityService
    include ActiveModel::Validations
    attr_accessor :activity_calification_id, :percentages, :activity_calification

    def initialize(attributes = {})
      @activity_calification_id = attributes[:activity_calification_id]
      @percentages = attributes[:percentages]
      @activity_calification = ActivityCalification.find(@activity_calification_id)
    end


    def call
      errors.add(:activity_calification_id, ' is already calificated') if activity_calification.state == "graded"

      unless errors.any?
        ActiveRecord::Base.transaction do
          bloom_taxonomy_levels = activity_calification.bloom_taxonomy_levels
          bloom_taxonomy_levels.each do |bloom_taxonomy_level|
            verb = bloom_taxonomy_level.verb
            percentage = get_level_score(verb)
            bloom_taxonomy_level.update(percentage: percentage)
          end

          activity_calification.complete!
        end
      end
      self
    end

    private

    def get_level_score(verb)
      upcase_verb = verb.upcase
      percentages[upcase_verb]
    end
  end
end
