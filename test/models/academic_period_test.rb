# == Schema Information
#
# Table name: academic_periods
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  number     :integer
#  start_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint           not null
#
# Indexes
#
#  index_academic_periods_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
require 'test_helper'

class AcademicPeriodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
