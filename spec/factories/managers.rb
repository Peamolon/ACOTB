# == Schema Information
#
# Table name: managers
#
#  id              :bigint           not null, primary key
#  position        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_profile_id :bigint           not null
#
# Indexes
#
#  index_managers_on_user_profile_id  (user_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_profile_id => user_profiles.id)
#
FactoryBot.define do
  factory :manager do
    user_profile { association(:user_profile) }
  end
end
