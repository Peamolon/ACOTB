require 'phonelib'
module Users
  class UserProfileCreatorService
    include ActiveModel::Validations
    attr_accessor :first_name, :last_name, :telephone, :role, :email, :username, :user, :user_profile
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :telephone, presence: true
    validates :email, presence: true
    validates :username, presence: true
    validates :role, presence: true

    def initialize(attributes = {})
      @first_name = attributes[:first_name]
      @last_name = attributes[:last_name]
      @telephone = attributes[:telephone]
      @role = attributes[:role]
      @email = attributes[:email]
      @username = attributes[:username]
    end

    def call
      errors.add(:telephone, 'is invalid') unless valid_telephone?
      errors.add(:rol, 'is invalid') unless valid_role?
      errors.add(:username, 'is already taken') if User.exists?(username: username)
      errors.add(:email, 'is already taken') if User.exists?(email: email)
      unless errors.any?
        ActiveRecord::Base.transaction do
          create_user
          create_user_profile
          #send_welcome_email
        end
      end
      self
    end

    private

    def send_welcome_email
      UserMailer.welcome_email(user).deliver_now
    end

    def create_user_profile
      @user_profile = UserProfile.create!(first_name: first_name, last_name: last_name, telephone: telephone, joined_at: Time.now, user_id: user.id)
    end

    def create_user
      @user = User.create!(email: email, username: username, password: '12345678')
    end

    def valid_telephone?
      phone = Phonelib.parse(telephone, 'CO')
      return phone.valid?
    end

    def valid_role?
      Role.is_valid?(role.to_sym)
    end
  end
end