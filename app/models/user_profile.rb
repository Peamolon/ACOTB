class UserProfile < ApplicationRecord
  rolify
  belongs_to :user

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :telephone, presence: true, length: { maximum: 30 }
  validates :joined_at, presence: true
  attr_accessor :role
  after_create :set_role

  private
  def set_role
    puts "El role es #{role}"
    self.add_role role.to_sym
  end
end
