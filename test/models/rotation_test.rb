# == Schema Information
#
# Table name: rotations
#
#  id                 :bigint           not null, primary key
#  end_date           :date
#  start_date         :date
#  state              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  academic_period_id :bigint           not null
#  institution_id     :bigint           not null
#  student_id         :bigint           not null
#  subject_id         :bigint           not null
#
# Indexes
#
#  index_rotations_on_academic_period_id  (academic_period_id)
#  index_rotations_on_institution_id      (institution_id)
#  index_rotations_on_student_id          (student_id)
#  index_rotations_on_subject_id          (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_period_id => academic_periods.id)
#  fk_rails_...  (institution_id => institutions.id)
#  fk_rails_...  (student_id => students.id)
#  fk_rails_...  (subject_id => subjects.id)
#
require 'test_helper'

class RotationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
