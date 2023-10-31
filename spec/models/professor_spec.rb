require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'Associations' do
    it { should belong_to(:user_profile) }
    it { should have_many(:subjects) }
    it { should have_many(:unities).through(:subjects) }
    it { should have_many(:activities).through(:unities) }
  end

  describe 'Instance Methods' do
    let(:user_profile) { create(:user_profile) }
    let(:professor) { create(:professor, user_profile: user_profile) }

    it 'returns the full name' do
      expect(professor.full_name).to eq("#{user_profile.first_name} #{user_profile.last_name}")
    end

    it 'returns the ID number' do
      expect(professor.id_number).to eq(user_profile.id_number)
    end

    it 'returns the ID type' do
      expect(professor.id_type).to eq(user_profile.id_type)
    end

    it 'returns the telephone' do
      expect(professor.telephone).to eq(user_profile.telephone)
    end
  end
end
