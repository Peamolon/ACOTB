module Subjects
  class EditSubjectService
    include ActiveModel::Validations

    attr_accessor :subject, :name, :credits, :academic_period_info, :rubric_info

    validates :name, presence: true
    validates :credits, presence: true

    def initialize(subject, attributes = {})
      @subject = subject
      @name = attributes[:name]
      @credits = attributes[:credits]
      @academic_period_info = attributes[:academic_period_info]
      @rubric_info = attributes[:rubric_info]
    end

    def call
      if rubric_info.present?
        has_valid_verbs?

        verbs_are_completed?
      end

      unless errors.any?
        ActiveRecord::Base.transaction do
          subject.update(name: name, credits: credits)

          update_rubrics if rubric_info.present?

          update_academic_periods if academic_period_info.present?
          subject
        end
      else
        self
      end

    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    end

    private

    def verbs_are_completed?
      valid_verbs = Rubric::LEVELS
      sent_verbs = rubric_info.map { |info| info[:verb] }

      missing_verbs = valid_verbs - sent_verbs
      unless missing_verbs.empty?
        errors.add(:rubric_info, "The following verbs are missing: #{missing_verbs.join(', ')}")
      end

      duplicate_verbs = sent_verbs.select { |verb| sent_verbs.count(verb) > 1 }.uniq
      unless duplicate_verbs.empty?
        errors.add(:rubric_info, "Duplicated verbs: #{duplicate_verbs.join(', ')}")
      end

      return errors.empty?
    end

    def has_valid_verbs?
      rubric_info.each do |info|
        unless Rubric::LEVELS.include?(info[:verb])
          errors.add(:rubric_info, "#{info[:verb]} is an invalid verb")
        end
      end
      return true
    end

    def update_rubrics
      rubric_info.each do |info|
        rubric = subject.rubrics.find_by(verb: info[:verb])
        rubric.update(description: info[:description]) if rubric
      end
    end

    def update_academic_periods
      academic_period_info.each do |info|
        academic_period = subject.academic_periods.find_by(number: info[:number])
        academic_period.update(start_date: info[:start_date], end_date: info[:end_date]) if academic_period
      end
    end
  end
end
