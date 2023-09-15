# == Schema Information
#
# Table name: rotations
#
#  id             :bigint           not null, primary key
#  end_date       :date
#  name           :string
#  start_date     :date
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  director_id    :bigint           not null
#  institution_id :bigint           not null
#  subject_id     :integer
#
# Indexes
#
#  index_rotations_on_director_id     (director_id)
#  index_rotations_on_institution_id  (institution_id)
#
# Foreign Keys
#
#  fk_rails_...  (director_id => directors.id)
#  fk_rails_...  (institution_id => institutions.id)
#
require 'test_helper'

class RotationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
