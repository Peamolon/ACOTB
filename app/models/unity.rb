# == Schema Information
#
# Table name: unities
#
#  id                 :bigint           not null, primary key
#  name               :string(200)
#  type               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  academic_period_id :bigint           not null
#  subject_id         :bigint           not null
#
# Indexes
#
#  index_unities_on_academic_period_id  (academic_period_id)
#  index_unities_on_subject_id          (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_period_id => academic_periods.id)
#  fk_rails_...  (subject_id => subjects.id)
#
class Unity < ApplicationRecord
  belongs_to :subject
  belongs_to :academic_period
  has_many :activities

  UNITY_TYPES = %w[MODULE WORKSHOP CURSE]
  public_constant :UNITY_TYPES

  validates :name, presence: true, length: {maximum: 200}
  validates :type, presence: true, inclusion: {in: UNITY_TYPES, message: "invalid unity type"}

  self.inheritance_column = :_type_disabled

  enum unity_type: {"module": 0, "workshop": 1, "curse": 2}

end
