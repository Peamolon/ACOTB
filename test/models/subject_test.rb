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
#  professor_id  :bigint           not null
#
# Indexes
#
#  index_subjects_on_professor_id  (professor_id)
#
# Foreign Keys
#
#  fk_rails_...  (professor_id => professors.id)
#
require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
