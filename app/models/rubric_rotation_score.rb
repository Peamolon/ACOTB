# == Schema Information
#
# Table name: rubric_rotation_scores
#
#  id          :bigint           not null, primary key
#  score       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rotation_id :bigint           not null
#  rubric_id   :bigint           not null
#
# Indexes
#
#  index_rubric_rotation_scores_on_rotation_id  (rotation_id)
#  index_rubric_rotation_scores_on_rubric_id    (rubric_id)
#
# Foreign Keys
#
#  fk_rails_...  (rotation_id => rotations.id)
#  fk_rails_...  (rubric_id => rubrics.id)
#
class RubricRotationScore < ApplicationRecord
  belongs_to :rotation
  belongs_to :rubric
end
