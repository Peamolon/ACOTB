module Subjects
  class DeleteSubjectService
    include ActiveModel::Validations

    attr_accessor :subject

    def initialize(subject:)
      @subject = subject
    end

    def call
      return self unless valid?

      ActiveRecord::Base.transaction do
        activities = @subject.activities

        unless activities.present?
          subject.academic_periods.destroy_all
          subject.rubrics.destroy_all
          subject.destroy
        else
          errors.add(:base, 'Subject has active activities')
        end
        self
      end
    rescue StandardError => e
      errors.add(:base, e.message)
      self
    end
  end
end
