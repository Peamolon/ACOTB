module ActivityCalifications
  class CalculateBloomTaxonomyAverageBySubjectAndPeriodService
    def self.student_evolutions(student_id, subject_id)
      student = Student.find(student_id)
      data = {}

      subject = Subject.find(subject_id)
      academic_periods = subject.academic_periods
      academic_periods.each do |academic_period|
        data[academic_period.number] = {} # Crear un nodo para el academic_period
        activity_califications = ActivityCalification.where(student_id: student_id)
                                                     .where(state: :graded)
                                                     .joins(:activity, :rotation)
                                                     .where(activities: { subject_id: subject.id })
                                                     .where(rotations: { academic_period_id: academic_period.id })
        data[academic_period.number] = calculate_average(activity_califications)
      end

      format_result(data)
    end

    def self.calculate_average(activity_califications)
      result = Hash.new { |hash, key| hash[key] = { total: 0, count: 0, subject_count: 0, average: 0.0 } }

      activity_califications.each do |activity_calification|
        activity_calification.bloom_taxonomy_levels.each do |level|
          result[level.verb][:total] += level.percentage
          result[level.verb][:count] += 1
          result[level.verb][:subject_count] += 1
        end
      end

      result.each do |verb, verb_data|
        total = verb_data[:total]
        count = verb_data[:count]
        subject_count = verb_data[:subject_count]
        verb_data[:average] = total / count.to_f
      end

      result
    end

    def self.format_result(data)
      formatted_result = {}
      data.each do |academic_period_number, bloom_data|
        formatted_result[academic_period_number] = {}
        bloom_data.each do |verb, verb_data|
          formatted_result[academic_period_number][verb] = verb_data[:average]
        end
      end
      formatted_result
    end
  end
end
