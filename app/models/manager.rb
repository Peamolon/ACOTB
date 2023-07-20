class Manager < ApplicationRecord
  belongs_to :user_profile
  after_create :set_manager_role
  validate :unique_user_profile

  private
  def set_manager_role
    user_profile.add_role :manager unless user_profile.has_role? :manager
  end

  def unique_user_profile
    if Manager.exists?(user_profile_id: user_profile_id)
      errors.add(:user_profile_id, 'already has a manager')
    end
  end
end
