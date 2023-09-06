# == Schema Information
#
# Table name: administrators
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_administrators_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
class Administrator < ApplicationRecord
  belongs_to :user_profile
  after_create :set_administrator_role
  validate :unique_user_profile

  private
  def set_administrator_role
    user_profile.add_role :administrator unless user_profile.has_role? :administrator
  end

  def unique_user_profile
    if Administrator.exists?(user_profile_id: user_profile_id)
      errors.add(:user_profile_id, 'already has an administrator')
    end
  end
end
