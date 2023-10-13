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
    manager_id: rand(1..Manager.count)
  }

  Rotation.create(rotation_params)
end


#Creating Subjects
def create_random_subject
  subject_params = {
    name: Faker::Educator.subject,
    credits: Faker::Number.between(from: 1, to: 5) * 3,
    rotation_id: rand(1..Rotation.count),
    manager_id: rand(1..Manager.count),
    professor_id: rand(1..Professor.count),
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
        verb: 'Recordar',
        description: 'Recordar '+ Faker::Lorem.word
      },
      {
        verb: 'Comprender',
        description: 'Comprender '+ Faker::Lorem.sentence
      },
      {
        verb: 'Aplicar',
        description: 'Aplicar '+ Faker::Lorem.word
      },
      {
        verb: 'Analizar',
        description: 'Analizar '+ Faker::Lorem.word
      },
      {
        verb: 'Evaluar',
        description: 'Evaluar '+ Faker::Lorem.word
      },
      {
        verb: 'Crear',
        description: 'Crear '+ Faker::Lorem.word
      },
    ]
  }

  ::Subjects::CreateSubjectService.new(subject_params).call
end

100.times do
  create_random_subject
end

#Create Unities
200.times do
  Unity.create!(
    name: Faker::Lorem.words(number: 3).join(' '),
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: AcademicPeriod.all.sample.id,
    subject_id: Subject.all.sample.id,
    )
end

#Assing subjects to students
def assign_rotations_to_students
  student_ids = Student.all.pluck(:id)
  rotation_ids = Rotation.all.pluck(:id)

  max_subjects_to_assign = 4

  student_ids.each do |student_id|
    num_subjects_to_assign = rand(1..max_subjects_to_assign)

    rotations_to_assign = rotation_ids.sample(num_subjects_to_assign)

    ::Students::AssignRotationService.new(rotations_to_assign, [student_id]).call
  end
end

5.times do
  assign_rotations_to_students
end


BLOOM_LEVELS = {
  "RECORDAR" => 0,
  "COMPRENDER" => 1,
  "APLICAR" => 2,
  "ANALIZAR" => 3,
  "EVALUAR" => 4,
  "CREAR" => 5
}.freeze

20.times do
  activity_params = {
    name: Faker::Lorem.sentence(word_count: 16),
    type: Activity::ACTIVITY_TYPES.sample,
    delivery_date: Faker::Date.between(from: Date.today, to: Date.today + 30.days),
    unity_id: 278,
    subject_id: 5,
    rotation_id: 1,
    bloom_levels: BLOOM_LEVELS.keys.sample(rand(1..6))
  }

  service = Activities::CreateActivityService.new(activity_params)
  service.call
end
