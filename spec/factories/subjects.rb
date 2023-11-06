# == Schema Information
#
# Table name: subjects
#
#  id            :bigint           not null, primary key
#  credits       :integer
#  name          :string
#  total_credits :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  professor_id  :bigint           not null
#
# Indexes
#
#  index_subjects_on_professor_id  (professor_id)
#
# Foreign Keys
#
#  fk_rails_...  (professor_id => professors.id)
#
FactoryBot.define do
  factory :subject do
    total_credits { 5 }
    credits { 3 }
    professor { association(:professor) }
  end
end
