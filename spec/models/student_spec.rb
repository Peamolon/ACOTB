# == Schema Information
#
# Table name: students
#
#  id              :bigint           not null, primary key
#  semester        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_students_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'Associations' do
    it { should belong_to(:user_profile) }
    it { should have_many(:activity_califications) }
    it { should have_many(:activities).through(:activity_califications) }
    it { should have_many(:rotations) }
    it { should have_many(:subjects).through(:rotations) }
  end

  describe 'Constants' do
    it 'should have ALLOWED_DOCUMENT_TYPES constant' do
      expect(described_class::ALLOWED_DOCUMENT_TYPES).to include('cc', 'identify_card', 'foreigner_id')
    end
  end

  describe 'Instance Methods' do
    let(:user_profile) { create(:user_profile) }
    let(:student) { create(:student, user_profile: user_profile) }

    it 'returns the full name' do
      expect(student.full_name).to eq("#{user_profile.first_name} #{user_profile.last_name}")
    end

    it 'returns the telephone' do
      expect(student.telephone).to eq(user_profile.telephone)
    end

    it 'returns the ID number' do
      expect(student.id_number).to eq(user_profile.id_number)
    end

    it 'returns the ID type' do
      expect(student.id_type).to eq(user_profile.id_type)
    end
  end
end
