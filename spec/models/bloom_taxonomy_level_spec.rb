# == Schema Information
#
# Table name: bloom_taxonomy_levels
#
#  id                       :bigint           not null, primary key
#  comment                  :text
#  level                    :integer
#  percentage               :integer
#  verb                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  activity_calification_id :bigint           not null
#
# Indexes
#
#  index_bloom_taxonomy_levels_on_activity_calification_id  (activity_calification_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_calification_id => activity_califications.id)
#
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
