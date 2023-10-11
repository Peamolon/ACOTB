# == Schema Information
#
# Table name: bloom_taxonomy_levels
#
#  id                       :bigint           not null, primary key
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
class BloomTaxonomyLevel < ApplicationRecord
  belongs_to :activity_calification
  has_one :activity, through: :activity_calification

  BLOOM_LEVELS = {
    "RECORDAR" => 0,
    "COMPRENDER" => 1,
    "APLICAR" => 2,
    "ANALIZAR" => 3,
    "EVALUAR" => 4,
    "CREAR" => 5
  }.freeze

  public_constant :BLOOM_LEVELS

  def activity_id
    activity.id
  end

end
