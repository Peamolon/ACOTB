module Subjects
  class CreateSubjectService
    include ActiveModel::Validations
    attr_accessor :name, :credits, :academic_period_info, :subject, :rubric_info, :professor_id, :rotation_id
    validates :name, presence: true
    validates :credits, presence: true
    validates :academic_period_info, presence: true
    validates :rubric_info, presence: true
    validates :professor_id, presence: true

    def initialize(attributes = {})
      @name = attributes[:name]
      @credits = attributes[:credits]
      @academic_period_info = attributes[:academic_period_info]
      @rotation_id = attributes[:rotation_id]
      @rubric_info = attributes[:rubric_info]
      @professor_id = attributes[:professor_id]
    end

    def call
      errors.add(:professor_id, 'must exist') unless Professor.exists?(id: professor_id)

      has_valid_verbs?
      verbs_are_completed?

      unless errors.any?
        ActiveRecord::Base.transaction do
          create_subject
          create_academic_periods
          create_rubric
        end
      end
      self
    end

    private

    def create_rubric
      rubric_info.each_with_index do |info, index|
        Rubric.create!(verb: info[:verb], level: index, description: info[:description], subject_id: subject.id)
      end
    end

    def create_subject
      @subject = Subject.create!(credits: credits,  name: name, professor_id: professor_id, rotation_id: rotation_id)
    end

    def create_academic_periods
      academic_period_info.each_with_index do |info, index|
        AcademicPeriod.create!(number: (index + 1), start_date: info[:start_date], end_date: info[:end_date], subject_id: subject.id)
      end
    end

    #Validations

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
  end
end