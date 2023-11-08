module BloomLevels
  class BloomTaxonomyReportService
    def self.calculate_averages_by_bloom_taxonomy(subject_id)
      activities = Activity.where(subject_id: subject_id).joins(:activity_califications).where.not(activity_califications: { numeric_grade: nil })


    end
  end

end