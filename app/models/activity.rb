# == Schema Information
#
# Table name: activities
#
#  id                    :bigint           not null, primary key
#  bloom_taxonomy_levels :string           default([]), is an Array
#  name                  :string(200)
#  state                 :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  subject_id            :bigint           not null
#  unity_id              :bigint           not null
#
# Indexes
#
#  index_activities_on_subject_id  (subject_id)
#  index_activities_on_unity_id    (unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (unity_id => unities.id)
#
class Activity < ApplicationRecord
  include AASM
  belongs_to :unity
  belongs_to :subject
  has_many :activity_califications

  ACTIVITY_TYPES = %w[THEORETICAL PRACTICAL THEORETICAL_PRACTICAL]
  public_constant :ACTIVITY_TYPES

  validates :name, presence: true, length: { maximum: 200 }
  validates :type, presence: true, inclusion:{in: ACTIVITY_TYPES, message: "invalid activity type"}
  validates :unity, presence: true

  before_validation :add_subject_rotation, on: :create

  #after_create :create_activity_califications

  scope :in_progress, -> { where(state: :in_progress)}

  self.inheritance_column = :_type_disabled

  aasm column: 'state' do
    state :pending, initial: true
    state :in_progress
    state :completed
    state :canceled
    state :postponed

    event :start do
      transitions from: :pending, to: :in_progress
    end

    event :complete do
      transitions from: [:pending, :in_progress], to: :completed
    end

    event :cancel do
      transitions from: [:pending, :in_progress], to: :canceled
    end

    event :postpone do
      transitions from: [:pending, :in_progress], to: :postponed
    end
  end

  def days_until_delivery
    return 0 if delivery_date.nil?

    difference = delivery_date - Date.today

    return 0 if difference.negative?

    difference.to_i
  end

  def calificate_student(student_id)
    student = Student.find(student_id)

    activity_califications = student.activity_califications

    activity_califications.each do |activity_calification|
      bloom_levels = activity_calification.bloom_taxonomy_levels
      bloom_levels.each do |bloom_level|
        bloom_level.update(percentage: rand(0..100))
      end
      activity_calification.complete! if activity_calification.state == "no_grade"
      activity_calification.update(numeric_grade: rand(1..5))
    end
  end

  private

  def add_subject_rotation
    subject_id = unity.subject_id
    self.subject_id = subject_id
  end

end
