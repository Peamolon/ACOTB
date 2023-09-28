module ActivityCalifications
  class CalculateBloomTaxonomyAverageService
    def initialize(activity_califications)
      @activity_califications = activity_califications
    end

    def call
      return {} if @activity_califications.empty?

      sum_hash = Hash.new(0)

      @activity_califications.each do |calification|
        calification.bloom_taxonomy_percentage.each do |key, value|
          sum_hash[key] += value
        end
      end

      num_califications = @activity_califications.length
      average_hash = sum_hash.transform_values { |value| value.to_f / num_califications }

      average_hash
    end
  end
end
