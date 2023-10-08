module Students
  class AssignRotationService
    def initialize(rotation_ids, student_ids)
      @rotation_ids = rotation_ids
      @student_ids = student_ids
    end

    def call
      students = Student.where(id: @student_ids)

      students.each do |student|
        @rotation_ids.each do |rotation_id|
          if student.rotations.pluck(:id).include?(rotation_id) || !Rotation.find(rotation_id).present?
            next
          end
          StudentInformation.create!(student_id: student.id, rotation_id: rotation_id)
        end
      end

      { success: true, message: 'Students were registered successfully' }
    end
  end

end