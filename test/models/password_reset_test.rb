# == Schema Information
#
# Table name: password_resets
#
#  id           :bigint           not null, primary key
#  code         :string(30)
#  ip_address   :string(60)
#  is_used      :boolean
#  password     :string(10)
#  requested_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_password_resets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class PasswordResetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
