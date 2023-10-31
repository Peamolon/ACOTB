require 'rails_helper'

RSpec.describe Rotation, type: :model do
  describe 'Associations' do
    it { should belong_to(:institution) }
    it { should belong_to(:student) }
    it { should belong_to(:subject) }
    it { should belong_to(:academic_period) }
    it { should have_many(:activity_califications) }
    it { should have_many(:activities).through(:activity_califications) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end

  describe 'Scopes' do
    it 'should have a scope to find active rotations' do
      expect(Rotation.active).to eq(Rotation.where(state: 'active'))
    end

    it 'should have a scope to find non-active rotations' do
      expect(Rotation.no_active).to eq(Rotation.where(state: 'no_active'))
    end

    it 'should have a scope to find next and past week rotations' do
      expect(Rotation.next_and_past_week_rotations).to be_truthy
    end
  end

  describe 'Instance Methods' do
    let(:rotation) { create(:rotation) }


    it 'should return institution name' do
      expect(rotation.institution_name).to eq(rotation.institution.name)
    end

    it 'should return student name' do
      expect(rotation.student_name).to eq(rotation.student.full_name)
    end
  end
end
