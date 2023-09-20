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
#  director_id   :integer
#  professor_id  :bigint
#
# Indexes
#
#  index_subjects_on_director_id   (director_id)
#  index_subjects_on_professor_id  (professor_id)
#
# Foreign Keys
#
#  fk_rails_...  (professor_id => professors.id)
#
class Subject < ApplicationRecord
  belongs_to :director, foreign_key: 'director_id', class_name: 'Director'
  belongs_to :professor, foreign_key: 'professor_id', class_name: 'Professor'
  has_many :rotations
  has_many :academic_periods
  has_many :rubrics
  has_many :academic_periods
  has_many :unities, through: :academic_periods

  def get_rubrics
    self.rubrics.pluck(:level, :verb, :description)
  end


end
