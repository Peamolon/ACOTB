module Students
  class StudentCalificationsService
    def initialize(attributes = {})
      @student_id = attributes[:student_id]
      @subject_id = attributes[:subject_id]
    end

    def calculate_califications
      calification_sum = calculate_calification_sum
      calification_count = calculate_calification_count
      average_califications = calculate_average_califications(calification_sum, calification_count)

      califications_hash = generate_califications_hash(average_califications)

      califications_hash
    end

    private

    def calculate_calification_sum
      ActivityCalification
        .joins(rotation: { academic_period: :subject })
        .where(student_id: @student_id)
        .where(rotations: { subject_id: @subject_id })
        .group('academic_periods.number')
        .sum(:numeric_grade)
    end

    def calculate_calification_count
      ActivityCalification
        .joins(rotation: { academic_period: :subject })
        .where(student_id: @student_id)
        .where(rotations: { subject_id: @subject_id })
        .group('academic_periods.number')
        .count
    end

    def calculate_average_califications(sum, count)
      average_califications = {}

      sum.each do |academic_period_number, total_sum|
        total_count = count[academic_period_number].to_f
        average_califications[academic_period_number] = (total_sum / total_count).round(2) if total_count.positive?
      end

      average_califications
    end

    def generate_califications_hash(average_califications)
      califications_hash = {}
      academic_period_numbers = Subject.find(@subject_id).academic_periods.pluck(:number)

      academic_period_numbers.each do |academic_period_number|
        califications_hash["academic_period_#{academic_period_number}"] = {}
        activity_calification = ActivityCalification
                                  .joins(rotation: { academic_period: :subject })
                                  .where(student_id: @student_id, rotations: { subject_id: @subject_id, state: :no_grade })
                                  .where('academic_periods.number = (?)', academic_period_number)
                                  .exists?

        if activity_calification
          califications_hash["academic_period_#{academic_period_number}"][:grade] = 0
          califications_hash["academic_period_#{academic_period_number}"][:message] = "incomplete"
        else
          califications_hash["academic_period_#{academic_period_number}"][:grade] = average_califications[academic_period_number]
          califications_hash["academic_period_#{academic_period_number}"][:message] = "complete"
        end
      end
      califications_hash
    end
  end
end