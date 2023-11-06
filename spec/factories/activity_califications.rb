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
FactoryBot.define do
  factory :activity_calification do
    before(:build) do |activity_calification|
      activity_calification.bloom_taxonomy_levels << FactoryBot.create(:bloom_taxonomy_level)
    end

    association :activity
    association :student
    association :rotation
    notes { Faker::Lorem.sentence }
    state { "no_grade"}
    numeric_grade { rand(1..10) }
    calification_date { Faker::Date.backward(days: 14) }
  end
end
