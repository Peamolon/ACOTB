# == Schema Information
#
# Table name: activity_califications
#
#  id                        :bigint           not null, primary key
#  bloom_taxonomy_percentage :text
#  calification_date         :date
#  notes                     :text
#  numeric_grade             :float
#  state                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  activity_id               :bigint           not null
#  rotation_id               :bigint           not null
#  student_id                :bigint           not null
#
# Indexes
#
#  index_activity_califications_on_activity_id  (activity_id)
#  index_activity_califications_on_rotation_id  (rotation_id)
#  index_activity_califications_on_student_id   (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_id => activities.id)
#  fk_rails_...  (rotation_id => rotations.id)
#  fk_rails_...  (student_id => students.id)
#
class ActivityCalification < ApplicationRecord
  include AASM
  belongs_to :activity
  belongs_to :student
  belongs_to :rotation
  has_many :bloom_taxonomy_levels

  validates :notes, length: { maximum: 255 }

  serialize :bloom_taxonomy_percentage, Hash

  aasm column: 'state' do
    state :no_grade, initial: true
    state :graded

    event :complete do
      transitions from: :no_grade, to: :graded
    end

    event :revert do
      transitions from: :graded, to: :no_grade
    end
  end

  def order_bloom_taxonomy_level
    bloom_taxonomy_levels.order(:level)
  end

  def academic_period
    rotation.academic_period
  end

  def activity_name
    activity.name
  end

  def rubrics
    subject.rubrics
  end
  def rotation_id
    rotation.id
  end

  def activity_type
    activity.type
  end

  def subject
    activity.unity.subject
  end

  def unity
    activity.unity
  end

  def unity_name
    unity = activity.unity
    unity.name
  end

  def subject_name
    subject.name
  end

  def unity_type
    unity = activity.unity
    unity.type
  end

  def student_name
    student.full_name
  end

  def as_json(options = {})
    super(options.merge(methods: [:activity_name, :unity_name, :subject_name, :activity_type, :rubrics, :academic_period]))
  end

  private

end
