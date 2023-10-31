FactoryBot.define do
  factory :academic_period do
    start_date { Time.zone.today }
    end_date { Time.zone.today + 1.year }
    number { 1 }
    association :subject, factory: :subject
  end
end
