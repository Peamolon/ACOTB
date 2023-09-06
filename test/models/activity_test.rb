# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  name       :string(200)
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unities_id :bigint           not null
#
# Indexes
#
#  index_activities_on_unities_id  (unities_id)
#
# Foreign Keys
#
#  fk_rails_...  (unities_id => unities.id)
#
require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
