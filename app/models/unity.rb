class Unity < ApplicationRecord
  belongs_to :user_profiles

  UNITY_TYPES = %w[MODULE WORKSHOP CURSE]
  public_constant :UNITY_TYPES

  validates :name, presence: true, length: {maximum: 200}
  validates :type, presence: true, inclusion: {in: UNITY_TYPES, message: "invalid unity type"}

  enum unity_type: {"module": 0, "workshop": 1, "curse": 2}

end
