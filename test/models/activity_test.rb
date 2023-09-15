# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  name       :string(200)
#  state      :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unity_id   :bigint           not null
#
# Indexes
#
#  index_activities_on_unity_id  (unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (unity_id => unities.id)
#
require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
