require 'rails_helper'

RSpec.describe BloomTaxonomyLevel, type: :model do
  describe 'Associations' do
    it { should belong_to(:activity_calification) }
    it { should have_one(:activity).through(:activity_calification) }
  end

  describe 'Constants' do
    it 'defines the expected BLOOM_LEVELS' do
      expected_levels = {
        "RECORDAR" => 0,
        "COMPRENDER" => 1,
        "APLICAR" => 2,
        "ANALIZAR" => 3,
        "EVALUAR" => 4,
        "CREAR" => 5
      }

      expect(BloomTaxonomyLevel::BLOOM_LEVELS).to eq(expected_levels)
    end
  end
end
