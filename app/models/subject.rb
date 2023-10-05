# == Schema Information
#
# Table name: subjects
#
#  id            :bigint           not null, primary key
#  credits       :integer
#  name          :string
#  total_credits :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  manager_id    :integer
#  professor_id  :bigint
#
# Indexes
#
#  index_subjects_on_manager_id    (manager_id)
#  index_subjects_on_professor_id  (professor_id)
#
# Foreign Keys
#
#  fk_rails_...  (professor_id => professors.id)
#
class Subject < ApplicationRecord
  belongs_to :manager, foreign_key: 'manager_id', class_name: 'Manager'
  belongs_to :professor, foreign_key: 'professor_id', class_name: 'Professor'
  has_many :rotations
  has_many :academic_periods
  has_many :rubrics
  has_many :academic_periods
  has_many :unities
  has_many :course_registrations
  has_many :students, through: :course_registrations

  has_many :rotation_subjects
  has_many :rotations, through: :rotation_subjects

  def activities
    Activity.where(unity_id: unities.pluck(:id))
  end

  def get_rubrics
    self.rubrics.pluck(:level, :verb, :description)
  end
end
