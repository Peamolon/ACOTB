module ActivityCalifications
  class CalculateBloomTaxonomyAverageService
    def self.average_percentage_and_subjects_by_student(student_id)
      activity_califications = ActivityCalification.where(student_id: student_id)

      total_percentages = Hash.new(0)

      count_by_level = Hash.new(0)

      average_percentages = Hash.new(0)

      subject_averages = Hash.new { |hash, key| hash[key] = Hash.new(0) }

      activity_califications.each do |calification|
        calification.bloom_taxonomy_levels.each do |level|
          next unless level.percentage.present?
          total_percentages[level.verb] += level.percentage
          count_by_level[level.verb] += 1
          subject_averages[level.verb][calification.activity.subject.name] += level.percentage
        end
      end

      total_percentages.each do |level, total|
        count = count_by_level[level]
        average_percentages[level] = count > 0 ? total / count.to_f : 0.0
      end

      subjects_worst_by_level = {}
      subjects_best_by_level = {}

      subject_averages.each do |level, subjects|
        sorted_subjects = subjects.sort_by { |subject, average| -average }
        subjects_worst_by_level[level] = sorted_subjects.last(3).to_h
        subjects_best_by_level[level] = sorted_subjects.first(3).to_h
      end

      average_percentages["activity_califications_count"] = activity_califications.count

      {
        average_percentages: average_percentages,
        subjects_worst_by_level: subjects_worst_by_level,
        subjects_best_by_level: subjects_best_by_level
      }
    end
  end
end
