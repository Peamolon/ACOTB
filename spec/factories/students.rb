FactoryBot.define do
  factory :student do
    user_profile { association(:user_profile) }
    semester { "3" }
  end
end
