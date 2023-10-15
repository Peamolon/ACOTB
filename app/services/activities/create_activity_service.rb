module Activities
  class CreateActivityService
    include ActiveModel::Validations
    attr_accessor :name, :type, :delivery_date, :unity_id, :subject_id, :bloom_levels, :rotation_id

    VALID_BLOOM_VERBS = %w(RECORDAR COMPRENDER APLICAR ANALIZAR EVALUAR CREAR).freeze

    def initialize(attributes = {})
      @name = attributes[:name]
      @type = attributes[:type]
      @delivery_date = attributes[:delivery_date]
      @unity_id = attributes[:unity_id]
      @subject_id = attributes[:subject_id]
      @bloom_levels = attributes[:bloom_levels]
      @rotation_id = attributes[:rotation_id]
    end


    def call
      errors.add(:bloom_levels, 'Can not repeat the verb') unless unique_bloom_levels
      errors.add(:type, 'is invalid') unless  Activity::ACTIVITY_TYPES.include?(type)

      unless valid_bloom_levels
        errors.add(:bloom_levels, 'No valid verbs are included')
        return self
      end

      ActiveRecord::Base.transaction do
        activity = Activity.new(
          name: @name,
          type: @type,
          delivery_date: @delivery_date,
          unity_id: @unity_id,
          subject_id: @subject_id,
          rotation_id: @rotation_id
        )
        if activity.save
          create_bloom_levels(activity)
        end
        self
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
