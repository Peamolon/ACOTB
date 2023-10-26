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
require 'test_helper'

class BloomTaxonomyLevelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
