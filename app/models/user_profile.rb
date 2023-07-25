class UserProfile < ApplicationRecord
  rolify
  belongs_to :user, touch: true
  has_one :student
  has_one :director
  has_one :administrator
  has_one :professor
  has_one :manager

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :telephone, presence: true, length: { maximum: 30 }
  validates :joined_at, presence: true
  attr_accessor :role
  #after_create :set_role

  def assign_role(role)
    sym = role.to_sym
    add_role sym
    case sym
    when :administrator
      Administrator.create(user_profile_id: self.id)
    when :student
      Student.create(user_profile_id: self.id)
    when :professor
      Professor.create(user_profile_id: self.id)
    when :manager
      Manager.create(user_profile_id: self.id)
    end
  end

  def add_role(role_name, resource = nil)
    unless Role.allowed_roles.include?(role_name.to_sym)
      raise ArgumentError, "Role #{role_name} is not allowed."
    end

    if has_role? role_name
      raise ArgumentError, "User has already role #{role_name}"
    end
    super
  end

  private
  def set_role
    assign_role(role)
  end
end
