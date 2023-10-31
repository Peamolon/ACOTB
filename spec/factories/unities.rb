FactoryBot.define do
  factory :unity do
    name { "Unity Name" }
    type { Unity::UNITY_TYPES.sample }
    association :academic_period, factory: :academic_period
    association :subject, factory: :subject
  end
end
