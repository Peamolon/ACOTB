# == Schema Information
#
# Table name: students
#
#  id              :bigint           not null, primary key
#  semester        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_students_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
FactoryBot.define do
  factory :student do
    user_profile { association(:user_profile) }
    semester { "3" }
  end
end
