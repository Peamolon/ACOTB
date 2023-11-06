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
