# == Schema Information
#
# Table name: activity_califications
#
#  id                        :bigint           not null, primary key
#  bloom_taxonomy_percentage :text
#  calification_date         :date
#  notes                     :text
#  numeric_grade             :float
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  activity_id               :bigint           not null
#  student_id                :bigint           not null
#
# Indexes
#
#  index_activity_califications_on_activity_id  (activity_id)
#  index_activity_califications_on_student_id   (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_id => activities.id)
#  fk_rails_...  (student_id => students.id)
#
class ActivityCalification < ApplicationRecord
  belongs_to :activity
  belongs_to :student

  validates :numeric_grade, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :notes, length: { maximum: 255 }

  serialize :bloom_taxonomy_percentage, Hash

  # Validar que los porcentajes de la taxonomía de Bloom sumen 100%
  validate :validate_bloom_taxonomy_percentage

  private

  # Método para validar que los porcentajes de la taxonomía de Bloom sumen 100%
  def validate_bloom_taxonomy_percentage
    unless bloom_taxonomy_percentage.is_a?(Hash) && bloom_taxonomy_percentage.values.all? { |value| value.is_a?(Numeric) }
      errors.add(:bloom_taxonomy_percentage, 'debe ser un hash con valores numéricos')
      return
    end
  end
end
