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
  has_many :academic_periods
  has_many :rubrics
  has_many :academic_periods
  has_many :unities
  has_many :activities

  def active_academic_period
    today = Date.today
    academic_periods.select do |academic_period|
      academic_period.start_date <= today && academic_period.end_date >= today
    end.max_by { |academic_period| academic_period.end_date }
  end


  def manager
    rotation.manager.full_name
  end

  def professor_name
    professor.full_name
  end

  def institution
    rotation.institution.name
  end
  def activities
    Activity.where(unity_id: unities.pluck(:id))
  end

  def get_rubrics
    self.rubrics.pluck(:level, :verb, :description)
  end

  def as_json(options = {})
    super(options.merge(methods: [:manager, :institution, :professor_name]))
  end
end
