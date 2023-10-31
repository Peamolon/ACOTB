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