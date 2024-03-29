module Activities
  class CreateActivityService
    include ActiveModel::Validations
    attr_accessor :name, :type, :unity_id, :bloom_levels

    VALID_BLOOM_VERBS = %w(RECORDAR COMPRENDER APLICAR ANALIZAR EVALUAR CREAR).freeze

    def initialize(attributes = {})
      @name = attributes[:name]
      @type = attributes[:type]
      @unity_id = attributes[:unity_id]
      @subject_id = attributes[:subject_id]
      @bloom_levels = attributes[:bloom_levels]
    end


    def call
      errors.add(:bloom_levels, 'No se pueden repetir los verbos de Bloom') unless unique_bloom_levels
      errors.add(:type, 'Tipo de actividad inválido') unless  Activity::ACTIVITY_TYPES.include?(type)
      errors.add(:unity_id, 'Debe existir') unless  Unity.exists?(id: unity_id)

      unity = Unity.find(unity_id)
      subject_id = unity.subject.id

      unless valid_bloom_levels
        errors.add(:bloom_levels, 'Hay verbos inválidos')
        return self
      end

      ActiveRecord::Base.transaction do
        activity = Activity.create!(
          name: @name,
          type: @type,
          subject_id: subject_id,
          unity_id: @unity_id,
          bloom_taxonomy_levels: bloom_levels
        )
        activity
      end
    end

    def create_bloom_levels(activity)
      activity.activity_califications.each do |activity_calification|
        @bloom_levels.each do |bloom_level|
          level = get_level(bloom_level)
          BloomTaxonomyLevel.create!(
            activity_calification: activity_calification,
            level: level,
            verb: bloom_level
          )
        end
      end
    end

    def get_level(bloom_level)
      upcase = bloom_level.upcase
      level = BloomTaxonomyLevel::BLOOM_LEVELS[upcase]
      level
    end

    def valid_bloom_levels
      @bloom_levels.all? { |verb| VALID_BLOOM_VERBS.include?(verb.upcase) }
    end

    def unique_bloom_levels
      @bloom_levels.uniq.length == @bloom_levels.length
    end
  end
end
