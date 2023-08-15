class Activity < ApplicationRecord
  belongs_to :unities

  validates :name, presence: true, length: { maximum: 200 }
  validates :type, presence: true

  enum activity_type: {"THEORETICAL": 0, "PRACTICAL": 1, "THEORETICAL_PRACTICAL": 2}

  ACTIVITY_TYPES = %w[THEORETICAL PRACTICAL THEORETICAL_PRACTICAL]
  public_constant :ACTIVITY_TYPES

end
