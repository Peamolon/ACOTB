# frozen_string_literal: true

# == Schema Information
#
# Table name: activity_califications
#
#  id                        :bigint           not null, primary key
#  bloom_taxonomy_percentage :text
#  calification_date         :date
#  notes                     :text
#  numeric_grade             :float
#  state                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  activity_id               :bigint           not null
#  rotation_id               :bigint           not null
#  student_id                :bigint           not null
#
# Indexes
#
#  index_activity_califications_on_activity_id  (activity_id)
#  index_activity_califications_on_rotation_id  (rotation_id)
#  index_activity_califications_on_student_id   (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_id => activities.id)
#  fk_rails_...  (rotation_id => rotations.id)
#  fk_rails_...  (student_id => students.id)
#
require 'rails_helper'

RSpec.describe ActivityCalification, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:activity) }
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:rotation) }
    it { is_expected.to have_many(:bloom_taxonomy_levels) }
  end
end
