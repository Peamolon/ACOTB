FactoryBot.define do
  factory :subject do
    total_credits { 5 }
    credits { 3 }
    professor { association(:professor) }
  end
end
