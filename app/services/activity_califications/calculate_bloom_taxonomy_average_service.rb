module ActivityCalifications
  class CalculateBloomTaxonomyAverageService
    def self.activities_with_highest_percentage_by_student(student_id)
      activity_califications = ActivityCalification.where(student_id: student_id)

      activities_highest_by_level = Hash.new { |hash, key| hash[key] = Hash.new(0) }

      activity_califications.each do |calification|
        calification.bloom_taxonomy_levels.each do |level|
          next unless level.percentage.present?
          activity_name = calification.activity.name
          current_percentage = level.percentage
          highest_percentages = activities_highest_by_level[level.verb]

          if current_percentage > highest_percentages["1st"].to_f
            highest_percentages["3rd"] = highest_percentages["2nd"]
            highest_percentages["2nd"] = highest_percentages["1st"]
            highest_percentages["1st"] = current_percentage
            highest_percentages["activity_3rd"] = highest_percentages["activity_2nd"]
            highest_percentages["activity_2nd"] = highest_percentages["activity_1st"]
            highest_percentages["activity_1st"] = activity_name
          elsif current_percentage > highest_percentages["2nd"].to_f
            highest_percentages["3rd"] = highest_percentages["2nd"]
            highest_percentages["2nd"] = current_percentage
            highest_percentages["activity_3rd"] = highest_percentages["activity_2nd"]
            highest_percentages["activity_2nd"] = activity_name
          elsif current_percentage > highest_percentages["3rd"].to_f
            highest_percentages["3rd"] = current_percentage
            highest_percentages["activity_3rd"] = activity_name
          end
        end
      end

      {
        activities_highest_by_level: activities_highest_by_level
      }
    end
  end
end
