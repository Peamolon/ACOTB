# == Schema Information
#
# Table name: directors
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_directors_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
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
