# == Schema Information
#
# Table name: course_registrations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :bigint           not null
#  subject_id :bigint           not null
#
# Indexes
#
#  index_course_registrations_on_student_id  (student_id)
#  index_course_registrations_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (student_id => students.id)
#  fk_rails_...  (subject_id => subjects.id)
#
require 'test_helper'

class CourseRegistrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
