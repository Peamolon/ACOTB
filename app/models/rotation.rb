class Rotation < ApplicationRecord
  belongs_to :rotation_type, :class_name => 'RotationType'
  belongs_to :institution
  belongs_to :director
end
