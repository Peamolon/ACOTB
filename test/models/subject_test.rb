# == Schema Information
#
# Table name: subjects
#
#  id            :bigint           not null, primary key
#  credits       :integer
#  name          :string
#  total_credits :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  director_id   :integer
#
# Indexes
#
#  index_subjects_on_director_id  (director_id)
#
require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
