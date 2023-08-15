class Activity < ApplicationRecord
  belongs_to :unities

  ACTIVITY_TYPES = %w[THEORETICAL PRACTICAL THEORETICAL_PRACTICAL]
  public_constant :ACTIVITY_TYPES

  validates :name, presence: true, length: { maximum: 200 }
  validates :type, presence: true, inclusion:{in: ACTIVITY_TYPES, message: "invalid activity type"}

  enum activity_type: {"theoretical": 0, "practical": 1, "theoretical_practical": 2}

end
