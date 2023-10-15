module ActivityCalifications
  class CalculateBloomTaxonomyAverageBySubjectService
    def self.student_evolutions(student_id, subject_id)
      activity_califications = ActivityCalification
                                 .joins(:activity)
                                 .where(student_id: student_id, activities: { subject_id: subject_id })
                                 .includes(:bloom_taxonomy_levels)

      data = Hash.new { |hash, key| hash[key] = [] }

      activity_califications.each do |calification|
        calification.bloom_taxonomy_levels.each do |level|
          data[level.verb] << {
            calification_date: calification.calification_date,
            percentage: level.percentage
          }
        end
      end
      data["activity_califications_count"] = activity_califications.count
      data
    end
  end
end


