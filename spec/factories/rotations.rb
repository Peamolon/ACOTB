FactoryBot.define do
  factory :rotation do
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 30) }
    state { 'active' } # Asegúrate de usar un estado válido ('active', 'no_active', etc.)

    # Añade las asociaciones necesarias
    association :institution
    association :student
    association :subject
    association :academic_period
  end
end

