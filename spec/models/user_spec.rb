# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  jti                    :string           not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "validates presence of required fields" do
      should validate_presence_of(:username)
      should validate_presence_of(:email)
      should validate_presence_of(:password)
    end

    it "validates uniqueness of username" do
      should validate_uniqueness_of(:username).case_insensitive
    end

    it "validates uniqueness of email" do
      should validate_uniqueness_of(:email).case_insensitive
    end

    it "validates email format" do
      should allow_value("user@example.com").for(:email)
      should_not allow_value("invalid_email").for(:email)
    end
  end

  it "is valid with valid attributes" do
    user = described_class.new(username: "example", email: "user@example.com", password: "password123")
    expect(user).to be_valid
  end
end
