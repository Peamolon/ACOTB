# == Schema Information
#
# Table name: unities
#
#  id               :bigint           not null, primary key
#  name             :string(200)
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_profiles_id :bigint           not null
#
# Indexes
#
#  index_unities_on_user_profiles_id  (user_profiles_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profiles_id => user_profiles.id)
#
require 'test_helper'

class UnityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
