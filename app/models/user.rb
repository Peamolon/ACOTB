# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  jti                    :string           not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  has_one :user_profile
  validates :username, presence: true, on: :create, uniqueness: true

  def current_profile
    user_profile if user_profile.present?
  end
  def jwt_payload
    super
  end

  private

  def set_user_profile
    begin
      UserProfile.create!(first_name: first_name, last_name: last_name, telephone: telephone, joined_at: Time.now, user_id: self.id, role: role)
    rescue => e
      raise e
    end
  end
  def valid_telephone?
    phone = Phonelib.parse(telephone, 'CO')
    unless phone.valid?
      errors.add(:telephone, 'is invalid')
    end
  end

  def valid_rol?
    unless Role.is_valid?(role.to_sym)
      errors.add(:rol, 'is invalid')
    end
  end
end
