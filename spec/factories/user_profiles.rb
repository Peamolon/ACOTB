FactoryBot.define do
  factory :user_profile do
    first_name { "John" }
    last_name { "Doe" }
    telephone { "123456789" }
    id_number { "12345" }
    id_type { "CC" }
    joined_at { Time.now }
    user { association(:user) }
  end
end
