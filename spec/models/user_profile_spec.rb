require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  describe "validations" do
    it "validates presence of required fields" do
      should validate_presence_of(:first_name)
      should validate_presence_of(:last_name)
      should validate_presence_of(:telephone)
      should validate_presence_of(:joined_at)
      should validate_presence_of(:id_number)
    end

    it "validates maximum length of fields" do
      should validate_length_of(:first_name).is_at_most(100)
      should validate_length_of(:last_name).is_at_most(100)
      should validate_length_of(:telephone).is_at_most(30)
    end
  end

  it "calculates the full name" do
    user_profile = described_class.new(first_name: "John", last_name: "Doe")
    expect(user_profile.full_name).to eq("John Doe")
  end

  it "retrieves the associated user's email" do
    user = User.create(username: "example", email: "user@example.com", password: "password123")
    user_profile = described_class.new(user: user)
    expect(user_profile.email).to eq("user@example.com")
  end

  it "retrieves the associated user's username" do
    user = User.create(username: "example", email: "user@example.com", password: "password123")
    user_profile = described_class.new(user: user)
    expect(user_profile.username).to eq("example")
  end
end
