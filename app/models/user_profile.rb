# == Schema Information
#
# Table name: user_profiles
#
#  id         :bigint           not null, primary key
#  first_name :string(100)
#  id_number  :string
#  id_type    :string
#  joined_at  :datetime
#  last_name  :string(100)
#  photo_url  :string(200)
#  settings   :json
#  telephone  :string(30)
#  timezone   :string(60)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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

  #enum id_type: { 'CC': 0, 'CE': 1, 'PA': 2, 'PE': 3 }

  attr_accessor :role
  #after_create :set_role
  def full_name
    "#{first_name} #{last_name}"
  end
  def email
    user.email
  end

  def username
    user.username
  end

  def role
    roles.last.name
  end

  def assigned_roles
    roles.pluck(:name)
  end

  def assign_role(role)
    sym = role.to_sym
    begin
      add_role sym
      case sym
      when :administrator
        Administrator.create!(user_profile_id: self.id)
      when :student
        Student.create!(user_profile_id: self.id)
      when :professor
        Professor.create!(user_profile_id: self.id)
      when :manager
        Manager.create!(user_profile_id: self.id)
      end
    rescue
      raise ArgumentError
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

  def as_json(options = {})
    super(options.merge(methods: [:email, :username, :assigned_roles, :role]))
  end

  private
  def set_role
    assign_role(role)
  end
end
