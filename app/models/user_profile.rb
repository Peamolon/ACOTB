class UserProfile < ApplicationRecord
  rolify
  belongs_to :user
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
  after_create :set_role
  def assign_roles
    if has_role? :administrator
      Administrator.create(user_profile_id: self.id)
    end
    if has_role? :student
      Student.create(user_profile_id: self.id)
    end
    if has_role? :proffesor
      Teacher.create(user_profile_id: self.id)
    end
    if has_role? :director
      Director.create(user_profile_id: self.id) if has_role?(:director)
    end
    if  has_role? :manager
      Manager.create(user_profile_id: self.id) if has_role?(:manager)
    end
  end

  private
  def set_role
    self.add_role role.to_sym
    assign_roles
  end
end
