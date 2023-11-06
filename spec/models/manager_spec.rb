# == Schema Information
#
# Table name: managers
#
#  id              :bigint           not null, primary key
#  position        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_managers_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
require 'rails_helper'

RSpec.describe Manager, type: :model do
  describe 'Associations' do
    it { should belong_to(:user_profile) }
    it { should have_many(:institutions) }
    it { should have_many(:rotations).through(:institutions) }
  end

  describe 'Instance Methods' do
    let(:user_profile) { create(:user_profile) }
    let(:manager) { create(:manager, user_profile: user_profile) }

    it 'returns the full name' do
      expect(manager.full_name).to eq("#{user_profile.first_name} #{user_profile.last_name}")
    end

    it 'returns the telephone' do
      expect(manager.telephone).to eq(user_profile.telephone)
    end

    it 'returns the ID number' do
      expect(manager.id_number).to eq(user_profile.id_number)
    end

    it 'returns the ID type' do
      expect(manager.id_type).to eq(user_profile.id_type)
    end

    it 'checks if manager is fully registered' do
      expect(manager.fully_registered?).to eq(manager.position.present?)
    end

  end

  describe 'Validations' do
    it 'ensures the user profile is unique' do
      user_profile = create(:user_profile)
      create(:manager, user_profile: user_profile)
      manager = build(:manager, user_profile: user_profile)
      expect(manager).not_to be_valid
    end
  end
end
