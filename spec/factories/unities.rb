# == Schema Information
#
# Table name: unities
#
#  id                 :bigint           not null, primary key
#  name               :string(200)
#  type               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  academic_period_id :bigint           not null
#  subject_id         :bigint           not null
#
# Indexes
#
#  index_unities_on_academic_period_id  (academic_period_id)
#  index_unities_on_subject_id          (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_period_id => academic_periods.id)
#  fk_rails_...  (subject_id => subjects.id)
#
FactoryBot.define do
  factory :unity do
    name { "Unity Name" }
    type { Unity::UNITY_TYPES.sample }
    association :academic_period, factory: :academic_period
    association :subject, factory: :subject
  end
end
