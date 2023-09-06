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
#
# Indexes
#
#  index_subjects_on_director_id  (director_id)
#
class Subject < ApplicationRecord
  belongs_to :director, foreign_key: 'director_id', class_name: 'Director'
  has_many :rotations
  has_many :academic_periods
  has_many :rubrics

end
