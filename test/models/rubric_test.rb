# == Schema Information
#
# Table name: rubrics
#
#  id          :bigint           not null, primary key
#  description :string(500)
#  level       :string(100)
#  verb        :string(200)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  subject_id  :bigint
#
# Indexes
#
#  index_rubrics_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
require 'test_helper'

class RubricTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
