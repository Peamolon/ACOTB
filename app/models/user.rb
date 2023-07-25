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
