require 'phonelib'
module Users
  class UserProfileCreatorService
    include ActiveModel::Validations
    attr_accessor :first_name, :last_name, :telephone, :role, :current_user
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :telephone, presence: true

    def initialize(first_name, last_name, telephone, role, current_user)
      @first_name = first_name
      @last_name = last_name
      @telephone = telephone
      @role = role
      @current_user = current_user
    end

    def call
      errors.add(:telephone, 'es invalido') unless valid_telephone?
      errors.add(:rol, 'es inválido') unless valid_role?
      unless errors.any?
        ActiveRecord::Base.transaction do
          UserProfile.create!(first_name: first_name, last_name: last_name, telephone: telephone, user_id: current_user.id, joined_at: Time.now)
        end
      end
      self
    end

    private

    def valid_telephone?
      phone = Phonelib.parse(telephone, 'CO')
      return phone.valid?
    end

    def valid_role?
      Role.is_valid?(role.to_sym)
    end
  end
end