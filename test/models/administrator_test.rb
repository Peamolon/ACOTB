# == Schema Information
#
# Table name: administrators
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_administrators_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
