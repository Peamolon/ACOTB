class UserProfile < ApplicationRecord
  rolify
  belongs_to :user, touch: true
  has_one :student
  has_one :director
  has_one :administrator
  has_one :professor
  has_one :manager

  DOCUMENT_TYPES = %w[CC CE PA PE]
  public_constant :DOCUMENT_TYPES

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :telephone, presence: true, length: { maximum: 30 }
  validates :joined_at, presence: true
  validates :id_number, presence: true
  validates :id_type, presence: true, inclusion: {in: DOCUMENT_TYPES, message: "invalid document type"}

  enum id_type: { CC: 0, CE: 1, PA: 2, PE: 3 }

  attr_accessor :role
  after_create :set_role

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

  private
  def set_role
    assign_role(role)
  end
end
