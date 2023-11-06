# == Schema Information
#
# Table name: institutions
#
#  id                :bigint           not null, primary key
#  code              :string(32)
#  contact_email     :string(128)
#  contact_telephone :string(30)
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  manager_id        :bigint           not null
#
# Indexes
#
#  index_institutions_on_manager_id  (manager_id)
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => managers.id)
#
FactoryBot.define do
  factory :institution do
    name { Faker::Company.name }
    code { Faker::Alphanumeric.alpha(number: 6) }
    contact_email { Faker::Internet.email }
    contact_telephone { Faker::PhoneNumber.phone_number }

    association :manager
  end
end
