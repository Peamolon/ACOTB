module Activities
  class EditActivityService
    include ActiveModel::Validations
    attr_accessor :activity_id, :name, :type, :unity_id, :bloom_levels

    VALID_BLOOM_VERBS = %w(RECORDAR COMPRENDER APLICAR ANALIZAR EVALUAR CREAR).freeze

    def initialize(id, attributes = {})
      @activity_id = id
      @name = attributes[:name]
      @type = attributes[:type]
      @unity_id = attributes[:unity_id]
      @bloom_levels = attributes[:bloom_levels]
    end

    def call
      activity = Activity.find_by(id: activity_id)

      unless activity
        errors.add(:activity_id, 'Actividad no encontrada')
        return self
      end

      if name.present?
        activity.name = name
      end

      if type.present? && Activity::ACTIVITY_TYPES.include?(type)
        activity.type = type
      end

      if unity_id.present? && Unity.exists?(id: unity_id)
        activity.unity_id = unity_id
        activity.subject_id = Unity.find(unity_id).subject.id
      end

      unless bloom_levels.nil?

        unless unique_bloom_levels
          errors.add(:bloom_levels, 'No se pueden repetir los verbos de Bloom') unless unique_bloom_levels
          return self
        end

        unless valid_bloom_levels
          errors.add(:bloom_levels, 'Hay verbos inválidos')
          return self
        end

        activity.bloom_taxonomy_levels = bloom_levels
      end

      if activity.changed?
        ActiveRecord::Base.transaction do
          activity.save!
        end
      end

      activity
    end

    def valid_bloom_levels
      bloom_levels.all? { |verb| VALID_BLOOM_VERBS.include?(verb.upcase) }
    end

    def unique_bloom_levels
      bloom_levels.uniq.length == bloom_levels.length
    end
  end
end
