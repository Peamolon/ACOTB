FactoryBot.define do
  factory :manager do
    user_profile { association(:user_profile) }
  end
end
