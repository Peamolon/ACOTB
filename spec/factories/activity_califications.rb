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
