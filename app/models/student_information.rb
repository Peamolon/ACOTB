# == Schema Information
#
# Table name: student_informations
#
#  id          :bigint           not null, primary key
#  end_at      :datetime
#  start_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rotation_id :bigint           not null
#  student_id  :bigint           not null
#
# Indexes
#
#  index_student_informations_on_rotation_id  (rotation_id)
#  index_student_informations_on_student_id   (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (rotation_id => rotations.id)
#  fk_rails_...  (student_id => students.id)
#
class StudentInformation < ApplicationRecord
  belongs_to :student
  belongs_to :rotation

  validates :start_date, presence: true

end
