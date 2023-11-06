module Activities
  class CalificateActivityService
    include ActiveModel::Validations
    attr_accessor :activity_calification_id, :percentages, :activity_calification, :comments, :numeric_grade

    validates :percentages, presence: true
    validates :comments, presence: true
    validates :numeric_grade, presence: true
    validate :validate_verbs_presence

    def initialize(attributes = {})
      @activity_calification_id = attributes[:activity_calification_id]
      @percentages = attributes[:percentages]
      @comments = attributes[:comments]
      @activity_calification = ActivityCalification.find(@activity_calification_id)
      @numeric_grade = attributes[:numeric_grade]
    end

    def call
      errors.add(:activity_calification_id, ' ya está calificado') if activity_calification.state == 'graded'
      unless percentages.present?
        errors.add(:percentages, 'No tiene porcentajes los niveles de bloom')
        return self
      end

      unless numeric_grade.present?
        errors.add(:numeric_grade, 'Falta la nota final')
        return self
      end

      unless comments.present?
        errors.add(:percentages, 'No tienen comentarios los niveles de bloom')
        return self
      end

      unless errors.any?
        bloom_taxonomy_levels = activity_calification.bloom_taxonomy_levels

        validate_comments_and_percentages(bloom_taxonomy_levels)

        if errors.empty?
          ActiveRecord::Base.transaction do
            bloom_taxonomy_levels.each do |bloom_taxonomy_level|
              verb = bloom_taxonomy_level.verb
              percentage = get_level_score(verb)
              comment = get_level_comment(verb)

              bloom_taxonomy_level.update(percentage: percentage, comment: comment)
            end
            activity_calification.complete!
            activity_calification.update(numeric_grade: numeric_grade)
            @activity_calification
          end
        end
      end
      self
    end

    private

    def get_level_score(verb)
      upcase_verb = verb.upcase
      percentages[upcase_verb]
    end

    def get_level_comment(verb)
      upcase_verb = verb.upcase
      comments[upcase_verb]
    end

    def validate_comments_and_percentages(bloom_taxonomy_levels)
      verb_errors = []

      bloom_taxonomy_levels.each do |bloom_taxonomy_level|
        verb = bloom_taxonomy_level.verb
        unless (percentages.key?(verb.upcase) && comments.key?(verb.upcase))
          verb_errors << verb
        end
      end

      if verb_errors.present?
        errors.add(:percentages, "Los siguientes verbos faltan por comentario o calificacion: #{verb_errors.join(', ')}")
      end
    end
  end
end
