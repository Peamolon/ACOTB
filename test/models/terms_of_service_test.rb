# == Schema Information
#
# Table name: terms_of_services
#
#  id         :bigint           not null, primary key
#  body       :string
#  publish_at :datetime
#  version    :string(10)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class TermsOfServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
