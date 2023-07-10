class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  has_one :user_profile
  attr_accessor :first_name, :last_name, :telephone, :role
  validates :first_name, presence: true, on: :create
  validates :last_name, presence: true, on: :create
  validates :telephone, presence: true, on: :create
  validates :username, presence: true, on: :create
  validate :valid_telephone?, on: :create
  validate :valid_rol?, on: :create
  after_create :set_user_profile

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
      errors.add(:telephone, 'es inválido')
    end
  end

  def valid_rol?
    unless Role.is_valid?(role.to_sym)
      errors.add(:rol, 'es invalido')
    end
  end
end
