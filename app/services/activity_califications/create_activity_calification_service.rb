module ActivityCalifications
  class CreateActivityCalificationService
    include ActiveModel::Validations
    attr_accessor :activity_id, :student_id, :numeric_grade, :notes, :calification_date, :bloom_taxonomy_percentage, :activity_calification

    validates :activity_id, presence: true
    validates :student_id, presence: true
    validates :numeric_grade, presence: true
    validates :calification_date, presence: true

    def initialize(attributes = {})
      @activity_id = attributes[:activity_id]
      @student_id = attributes[:student_id]
      @numeric_grade = attributes[:numeric_grade]
      @notes = attributes[:notes]
      @calification_date = attributes[:calification_date]
      @bloom_taxonomy_percentage = attributes[:bloom_taxonomy_percentage]
    end

    def call
      unless Activity.exists?(id: activity_id)
        errors.add(:activity_id, 'Activity not found')
      end

      unless Student.exists?(id: student_id)
        errors.add(:student_id, 'Student not found')
      end

      bloom_taxonomy_params = bloom_taxonomy_percentage.to_hash
      puts bloom_taxonomy_params

      unless errors.any?
        @activity_calification = ActivityCalification.create!(
          activity_id: activity_id,
          student_id: student_id,
          numeric_grade: numeric_grade,
          notes: notes,
          calification_date: calification_date,
          bloom_taxonomy_percentage: bloom_taxonomy_params
        )
      end
      self
    end
  end
end
