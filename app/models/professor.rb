class Professor < ApplicationRecord
  belongs_to :user_profile
  after_create :set_professor_role
  validate :unique_user_profile

  private
  def set_professor_role
    user_profile.add_role :professor unless user_profile.has_role? :professor
  end

  def unique_user_profile
    if Professor.exists?(user_profile_id: user_profile_id)
      errors.add(:user_profile_id, 'already has a professor')
    end
  end
end
