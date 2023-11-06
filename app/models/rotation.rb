# == Schema Information
#
# Table name: rotations
#
#  id                 :bigint           not null, primary key
#  end_date           :date
#  numeric_grade      :float
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
class Rotation < ApplicationRecord
  include AASM
  belongs_to :institution
  has_one :manager, through: :institution
  belongs_to :student
  belongs_to :subject
  belongs_to :academic_period
  has_many :activity_califications
  has_many :activities, through: :activity_califications


  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :active, -> { where(state: :active) }
  scope :no_active, -> { where(state: :no_active) }

  scope :next_and_past_week_rotations, -> {
    today = Date.current
    start_of_next_week = today.beginning_of_week(:sunday) + 1.week
    end_of_next_week = start_of_next_week.end_of_week(:sunday)

    where("start_date >= ? AND start_date <= ?", today, end_of_next_week)
  }

  def graded_percentage
    graded_califications = activity_califications.where(state: 'graded')
    return Float((graded_califications.count.to_f / activity_califications.count.to_f) * 100)
  end

  def institution_name
    institution.name
  end

  def student_name
    student.full_name
  end

  def manager_name
    manager.user_profile.full_name
  end

  def subject_name
    subject.name
  end

  def academic_period_number
    academic_period.number
  end

  def as_json(options = {})
    super(options.merge(methods: [:manager_name, :institution_name,
                                  :subject_name, :academic_period_number,
                                  :student_name, :graded_percentage]))
  end
end
