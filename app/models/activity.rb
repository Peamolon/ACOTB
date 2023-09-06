# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  name       :string(200)
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unities_id :bigint           not null
#
# Indexes
#
#  index_activities_on_unities_id  (unities_id)
#
# Foreign Keys
#
#  fk_rails_...  (unities_id => unities.id)
#
class Activity < ApplicationRecord
  belongs_to :unities

  ACTIVITY_TYPES = %w[THEORETICAL PRACTICAL THEORETICAL_PRACTICAL]
  public_constant :ACTIVITY_TYPES

  validates :name, presence: true, length: { maximum: 200 }
  validates :type, presence: true, inclusion:{in: ACTIVITY_TYPES, message: "invalid activity type"}

  enum activity_type: {"theoretical": 0, "practical": 1, "theoretical_practical": 2}

end
