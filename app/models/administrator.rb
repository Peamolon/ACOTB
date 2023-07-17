class Administrator < ApplicationRecord
  belongs_to :user_profile
  after_create :set_administrator_role
  validate :unique_user_profile

  private
  def set_administrator_role
    user_profile.add_role :administrator
  end

  def unique_user_profile
    if Administrator.exists?(user_profile_id: user_profile_id)
      errors.add(:user_profile_id, 'already has an administrator')
    end
  end
end
