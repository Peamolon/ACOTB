FactoryBot.define do
  factory :institution do
    name { Faker::Company.name }
    code { Faker::Alphanumeric.alpha(number: 6) }
    contact_email { Faker::Internet.email }
    contact_telephone { Faker::PhoneNumber.phone_number }

    association :manager
  end
end
