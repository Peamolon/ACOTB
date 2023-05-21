class Role < ApplicationRecord
  has_and_belongs_to_many :user_profiles, :join_table => :user_profiles_roles
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  ALLOWED_ROLES = [:administrator, :student, :proffesor, :director, :manager, :superadmin]

  def self.allowed_roles
    ALLOWED_ROLES
  end

  def self.is_valid?(role)
    ALLOWED_ROLES.include?(role)
  end
end
