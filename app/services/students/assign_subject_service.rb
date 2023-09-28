module Students
  class AssignSubjectService
    def initialize(subjects_id, student_ids)
      @subjects_id = subjects_id
      @student_ids = student_ids
    end

    def call
      students = Student.where(id: @student_ids)

      students.each do |student|
        @subjects_id.each do |subject_id|
          if student.subjects.pluck(:id).include?(subject_id) || !Subject.find(subject_id).present?
            next
          end
          CourseRegistration.create!(student_id: student.id, subject_id: subject_id)
        end
      end

      { success: true, message: 'Students were registered successfully' }
    end
  end

end