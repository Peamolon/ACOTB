# == Schema Information
#
# Table name: activities
#
#  id                    :bigint           not null, primary key
#  bloom_taxonomy_levels :string           default([]), is an Array
#  name                  :string(200)
#  state                 :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  subject_id            :bigint           not null
#  unity_id              :bigint           not null
#
# Indexes
#
#  index_activities_on_subject_id  (subject_id)
#  index_activities_on_unity_id    (unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (unity_id => unities.id)
#
FactoryBot.define do
  factory :activity do
    notes { "Some notes for the activity calification" }
    numeric_grade { 8.5 }
    state { "no_grade" }

    association :activity
    association :student
    association :rotation
  end
end
