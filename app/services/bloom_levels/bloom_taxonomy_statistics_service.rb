module BloomLevels
  class BloomTaxonomyStatisticsService
    def self.activities_by_bloom_verbs(subject_id)
      subject = Subject.find(subject_id)
      activities = subject.activities

      bloom_verb_counts = {}
      bloom_verb_notes = {}

      activities.each do |activity|
        bloom_levels = activity.bloom_taxonomy_levels
        next if bloom_levels.blank?

        bloom_levels.each do |verb|
          bloom_verb_counts[verb] ||= 0
          bloom_verb_counts[verb] += 1

          activity.activity_califications.each do |calification|
            next if calification.numeric_grade.nil?

            bloom_verb_notes[verb] ||= []
            bloom_verb_notes[verb] << calification.numeric_grade
          end
        end
      end

      bloom_verb_averages = {}
      bloom_verb_notes.each do |verb, grades|
        bloom_verb_averages[verb] = (grades.sum / grades.size.to_f).round(2)
      end

      { counts: bloom_verb_counts, averages: bloom_verb_averages }
    end

    def self.average_grades_by_academic_period(subject_id)
      rotations = Rotation.where(subject_id: subject_id).includes(:activity_califications).where.not(activity_califications: { numeric_grade: nil })
      califications_by_period = rotations.group_by { |rotation| rotation.academic_period.number }

      average_grades_by_period = {}
      califications_by_period.each do |period_number, rotations|
        total_grades = rotations.map { |rotation| rotation.activity_califications.pluck(:numeric_grade) }.flatten
        average_grades_by_period[period_number] = (total_grades.sum.to_f / total_grades.length).round(2)
      end

      average_grades_by_period
    end

    def self.institutions_with_most_rotations
      Rotation.joins(:institution).group('institutions.name').count
    end
  end
end