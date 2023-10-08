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
#  professor_id  :bigint
#  rotation_id   :bigint
#
# Indexes
#
#  index_subjects_on_professor_id  (professor_id)
#  index_subjects_on_rotation_id   (rotation_id)
#
# Foreign Keys
#
#  fk_rails_...  (professor_id => professors.id)
#  fk_rails_...  (rotation_id => rotations.id)
#
class Subject < ApplicationRecord
  belongs_to :rotation
  belongs_to :professor, foreign_key: 'professor_id', class_name: 'Professor'
  has_many :rotations
  has_many :academic_periods
  has_many :rubrics
  has_many :academic_periods
  has_many :unities
  has_many :activities

  def activities
    Activity.where(unity_id: unities.pluck(:id))
  end

  def get_rubrics
    self.rubrics.pluck(:level, :verb, :description)
  end
end
