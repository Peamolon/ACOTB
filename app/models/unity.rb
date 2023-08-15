class Unity < ApplicationRecord
  belongs_to :user_profiles


  validates :name, presence: true, length: { maximum: 200 }
  validates :type, presence: true

  enum unity_type: {"M": 0, "W": 1, "C": 2}

  UNITY_TYPES = %w[MODULE WORKSHOP CURSE]
  public_constant :UNITY_TYPES
end
