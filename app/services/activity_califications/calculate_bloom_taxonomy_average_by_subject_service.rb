module ActivityCalifications
  class CalculateBloomTaxonomyAverageBySubjectService
    def initialize(student)
      @student = student
    end

    def call
      result = []

      @student.subjects.each do |subject|
        average_result = calculate_average_for_subject(subject)
        result << {
          id: subject.id,
          name: subject.name,
          credits: subject.credits,
          rubrics: subject.rubrics,
          average_result: average_result
        }
      end

      result
    end

    private

    def calculate_average_for_subject(subject)
      califications_for_subject = @student.activity_califications.joins(activity: { unity: :subject }).where(subjects: { id: subject.id })
      return {} if califications_for_subject.empty?

      sum_hash = Hash.new(0)

      califications_for_subject.each do |calification|
        calification.bloom_taxonomy_percentage.each do |key, value|
          sum_hash[key] += value
        end
      end

      num_califications = califications_for_subject.length
      average_hash = sum_hash.transform_values { |value| value.to_f / num_califications }

      average_hash
    end
  end
end


