class RubricRotationScore < ApplicationRecord
  belongs_to :rotation
  belongs_to :rubric
end
