# == Schema Information
#
# Table name: activities
#
#  id            :bigint           not null, primary key
#  delivery_date :date
#  name          :string(200)
#  state         :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rotation_id   :bigint           not null
#  subject_id    :bigint           not null
#  unity_id      :bigint           not null
#
# Indexes
#
#  index_activities_on_rotation_id  (rotation_id)
#  index_activities_on_subject_id   (subject_id)
#  index_activities_on_unity_id     (unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (rotation_id => rotations.id)
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (unity_id => unities.id)
#
require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
