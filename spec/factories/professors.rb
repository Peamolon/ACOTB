FactoryBot.define do
  factory :professor do
    user_profile { association(:user_profile) }
  end
end
