#Creating users
100.times do
  user_params = {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    telephone: "3#{rand(11..20)}#{rand(0..9999999).to_s.rjust(7, '0')}",
    role: Role.allowed_roles.sample,
    email: Faker::Internet.email,
    username: Faker::Internet.username,
    id_number: Faker::IDNumber.valid,
    id_type: UserProfile::DOCUMENT_TYPES.sample,
    joined_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
  }

  service = ::Users::UserProfileCreatorService.new(user_params)
  service.call
end

#Creating Institutions
30.times do
  institution_params = {
    name: Faker::Company.name,
    code: Faker::Alphanumeric.alpha(number: 6).upcase,
    contact_email: Faker::Internet.email,
    contact_telephone: Faker::PhoneNumber.cell_phone,
    manager_id: Manager.all.sample.id
  }

  Institution.create!(institution_params)
end

#Creating rotations
20.times do
  rotation_params = {
    name: Faker::Company.name,
    start_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now),
    end_date: Faker::Date.between(from: 1.month.from_now, to: 3.months.from_now),
    institution_id: rand(1..Institution.count),
    director_id: rand(1..Director.count)
  }

  Rotation.create(rotation_params)
end


#Creating Subjects
def create_random_subject
  subject_params = {
    name: Faker::Educator.subject,
    credits: Faker::Number.between(from: 1, to: 5) * 3,
    director_id: rand(1..Director.count),
    academic_period_info: [
      {
        start_date: Faker::Date.between(from: '2023-09-01', to: '2023-12-15'),
        end_date: Faker::Date.between(from: '2023-12-16', to: '2024-04-30')
      },
      {
        start_date: Faker::Date.between(from: '2024-09-01', to: '2024-12-15'),
        end_date: Faker::Date.between(from: '2024-12-16', to: '2025-04-30')
      }
    ],
    rubric_info: [
      {
        verb: 'Recordar '+ Faker::Lorem.word,
        description: Faker::Lorem.sentence
      },
      {
        verb: 'Comprender '+ Faker::Lorem.word,
        description: Faker::Lorem.sentence
      },
      {
        verb: 'Aplicar '+ Faker::Lorem.word,
        description: Faker::Lorem.sentence
      },
      {
        verb: 'Analizar '+ Faker::Lorem.word,
        description: Faker::Lorem.sentence
      },
      {
        verb: 'Evaluar '+ Faker::Lorem.word,
        description: Faker::Lorem.sentence
      },
      {
        verb: 'Crear '+ Faker::Lorem.word,
        description: Faker::Lorem.sentence
      },
    ]
  }

  ::Subjects::CreateSubjectService.new(subject_params).call
end

100.times do
  create_random_subject
end

#Create Unities
100.times do
  Unity.create!(
    name: Faker::Lorem.words(number: 3).join(' '),
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: AcademicPeriod.all.sample.id,
    subject_id: Subject.all.sample.id,
    )
end


#create activities
200.times do
  Activity.create!(
    unity_id: Unity.all.sample.id,
    type: Activity::ACTIVITY_TYPES.sample,
    name: Faker::Lorem.sentence(word_count: 3)
  )
end








