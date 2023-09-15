# == Schema Information
#
# Table name: rotation_types
#
#  id          :bigint           not null, primary key
#  approved    :boolean          default(FALSE)
#  credits     :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class RotationTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
