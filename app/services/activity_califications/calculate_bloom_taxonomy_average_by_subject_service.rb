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
      activities_id = subject.activities.pluck(:id)
      activity_califications = ActivityCalification.where(activity_id: activities_id).where(student_id: @student.id)

      return {} if activity_califications.empty?

      result = ::ActivityCalifications::CalculateBloomTaxonomyAverageService.new(activity_califications).call

      result
    end
  end
end


