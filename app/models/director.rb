class Director < ApplicationRecord
  belongs_to :user_profile
  has_many :subjects
  after_create :set_director_role
  validate :unique_user_profile

  private
  def set_director_role
    user_profile.add_role :director unless user_profile.has_role? :director
  end

  def unique_user_profile
    if Director.exists?(user_profile_id: user_profile_id)
      errors.add(:user_profile_id, 'already has a director')
    end
  end
end
