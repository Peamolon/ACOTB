# == Schema Information
#
# Table name: rotations
#
#  id                 :bigint           not null, primary key
#  end_date           :date
#  numeric_grade      :float
#  start_date         :date
#  state              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  academic_period_id :bigint           not null
#  institution_id     :bigint           not null
#  student_id         :bigint           not null
#  subject_id         :bigint           not null
#
# Indexes
#
#  index_rotations_on_academic_period_id  (academic_period_id)
#  index_rotations_on_institution_id      (institution_id)
#  index_rotations_on_student_id          (student_id)
#  index_rotations_on_subject_id          (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_period_id => academic_periods.id)
#  fk_rails_...  (institution_id => institutions.id)
#  fk_rails_...  (student_id => students.id)
#  fk_rails_...  (subject_id => subjects.id)
#
FactoryBot.define do
  factory :rotation do
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 30) }
    state { 'active' } # Asegúrate de usar un estado válido ('active', 'no_active', etc.)

    # Añade las asociaciones necesarias
    association :institution
    association :student
    association :subject
    association :academic_period
  end
end

