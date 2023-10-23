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
#  professor_id  :bigint           not null
#
# Indexes
#
#  index_subjects_on_professor_id  (professor_id)
#
# Foreign Keys
#
#  fk_rails_...  (professor_id => professors.id)
#
class Subject < ApplicationRecord
  belongs_to :professor
  has_many :academic_periods
  has_many :rubrics
  has_many :unities
  has_many :activities

  def active_academic_period
    today = Date.today
    academic_periods.select do |academic_period|
      academic_period.start_date <= today && academic_period.end_date >= today
    end.max_by { |academic_period| academic_period.end_date }
  end

  def academic_period_for_date(date)
    academic_periods.find do |academic_period|
      academic_period.start_date <= date && academic_period.end_date >= date
    end
  end


  def manager
    rotation.manager.full_name
  end

  def professor_name
    professor.full_name
  end
  def activities
    Activity.where(unity_id: unities.pluck(:id))
  end

  def get_rubrics
    self.rubrics.pluck(:level, :verb, :description)
  end

  def as_json(options = {})
    super(options.merge(
      include: { rubrics: { only: [:level, :verb, :description] } }
    ))
  end
end
