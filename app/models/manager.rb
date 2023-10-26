# == Schema Information
#
# Table name: managers
#
#  id              :bigint           not null, primary key
#  position        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_managers_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
class Manager < ApplicationRecord
  belongs_to :user_profile
  after_create :set_manager_role
  validate :unique_user_profile
  has_many :institutions
  has_many :rotations, through: :institutions

  def subjects
    rotations.map{|rotation| rotation.subjects}
  end

  def fully_registered?
    position.present?
  end

  def full_name
    "#{user_profile.first_name} #{user_profile.last_name}"
  end

  def id_number
    user_profile.id_number
  end

  def id_type
    user_profile.id_type
  end

  def telephone
    user_profile.telephone
  end

  def as_json(options = {})
    super(options.merge(methods: [:full_name, :telephone, :id_number, :id_type]))
  end

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
