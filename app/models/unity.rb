# == Schema Information
#
# Table name: unities
#
#  id               :bigint           not null, primary key
#  name             :string(200)
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_profiles_id :bigint           not null
#
# Indexes
#
#  index_unities_on_user_profiles_id  (user_profiles_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profiles_id => user_profiles.id)
#
class Unity < ApplicationRecord
  belongs_to :user_profiles

  UNITY_TYPES = %w[MODULE WORKSHOP CURSE]
  public_constant :UNITY_TYPES

  validates :name, presence: true, length: {maximum: 200}
  validates :type, presence: true, inclusion: {in: UNITY_TYPES, message: "invalid unity type"}

  enum unity_type: {"module": 0, "workshop": 1, "curse": 2}

end
