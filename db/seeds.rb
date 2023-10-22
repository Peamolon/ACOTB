#Creating users
20.times do
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

#Creates default user
user_params = {
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  telephone: "3#{rand(11..20)}#{rand(0..9999999).to_s.rjust(7, '0')}",
  role: 'student',
  email: Faker::Internet.email,
  username: 'student',
  id_number: Faker::IDNumber.valid,
  id_type: UserProfile::DOCUMENT_TYPES.sample,
  joined_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
}

service = ::Users::UserProfileCreatorService.new(user_params)
service.call



names =["Hospital Universitario Centro Dermatologico Federico Lleras Acosta E.S.E","CENTRO MEDICO IMBANACO DE CALI ","SOMA","HOSPITAL NAVAL CARTAGENA ","IDIME ","SUBRED INTEGRADA DE SERVICIOS DE SALUD NORTE ","SUBRED INTEGRADA DE SERVICIOS DE SALUD SUROCCIDENTE ","SUBRED INTEGRADA DE SERVICIOS DE SALUD CENTROORIENTE ","CLINICA VASCULAR NAVARRA ","UNIVERSIDAD DEL NORTE ","CLINICOS IPS ","CAFAM"]


#Creating Institutions
names.each do |name|
  institution_params = {
    name: name,
    code: Faker::Alphanumeric.alpha(number: 6).upcase,
    contact_email: Faker::Internet.email,
    contact_telephone: Faker::PhoneNumber.cell_phone,
    manager_id: Manager.all.sample.id
  }

  Institution.create!(institution_params)
end

#Creating Subjects
def create_random_subject
  subject_params = {
    name: Faker::Educator.subject,
    credits: Faker::Number.between(from: 1, to: 5) * 3,
    manager_id: rand(1..Manager.count),
    professor_id: rand(1..Professor.count),
    academic_period_info: [
      {
        start_date: '01/06/2023',
        end_date: '01/08/2023'
      },
      {
        start_date: '01/08/2023',
        end_date: '01/09/2023'
      },
      {
        start_date: '01/09/2023',
        end_date: '01/12/2023'
      }
    ],
    rubric_info: [
      {
        verb: 'Recordar',
        description: 'Recordar '+ Faker::Lorem.paragraph(sentence_count: 10)
      },
      {
        verb: 'Comprender',
        description: 'Comprender '+ Faker::Lorem.paragraph(sentence_count: 10)
      },
      {
        verb: 'Aplicar',
        description: 'Aplicar '+ Faker::Lorem.paragraph(sentence_count: 10)
      },
      {
        verb: 'Analizar',
        description: 'Analizar '+ Faker::Lorem.paragraph(sentence_count: 10)
      },
      {
        verb: 'Evaluar',
        description: 'Evaluar '+ Faker::Lorem.paragraph(sentence_count: 10)
      },
      {
        verb: 'Crear',
        description: 'Crear '+ Faker::Lorem.paragraph(sentence_count: 10)
      },
    ]
  }

  ::Subjects::CreateSubjectService.new(subject_params).call
end

10.times do
  create_random_subject
end

#Create Unities
50.times do
  Unity.create!(
    name: Faker::Lorem.words(number: 3).join(' '),
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: AcademicPeriod.all.sample.id,
    subject_id: Subject.all.sample.id,
    )
end


BLOOM_LEVELS = {
  "RECORDAR" => 0,
  "COMPRENDER" => 1,
  "APLICAR" => 2,
  "ANALIZAR" => 3,
  "EVALUAR" => 4,
  "CREAR" => 5
}.freeze

60.times do
  activity_params = {
    name: Faker::Lorem.sentence(word_count: 16),
    type: Activity::ACTIVITY_TYPES.sample,
    unity_id: rand(1..Unity.count),
    bloom_levels: BLOOM_LEVELS.keys.sample(rand(1..6))
  }

  service = Activities::CreateActivityService.new(activity_params)
  service.call
end



student_id = User.find_by(username: 'student').user_profile.student.id
start_date = Date.new(2023, 7, 1)
end_date = Date.new(2023, 12, 31)
institutions = Institution.all.sample(5)

(start_date..end_date).select { |date| date.wday == start_date.wday }.each do |week_start|
  week_end = week_start + 6.days # End of the week

  institutions.each do |institution|
    subject = Subject.all.sample
    activities = subject.activities
    selected_activities = activities.sample(rand(2..3))

    rotation_params = {
      student_id: student_id,
      subject_id: subject.id,
      institution_id: institution.id,
      start_date: week_start,
      end_date: week_end,
      activities_ids: selected_activities.pluck(:id)
    }

    rotation_service = Rotations::AssignRotationService.new(rotation_params)
    result = rotation_service.call

    if result[:success]
      puts "Rotation created for student #{student_id} at #{institution.name} for the week starting on #{week_start}"
    else
      puts "Error creating rotation: #{result[:errors]}"
    end
  end
end

def calificate_student(student_id)
  student = Student.find(student_id)

  activity_califications = student.activity_califications

  activity_califications.each do |activity_calification|
    bloom_levels = activity_calification.bloom_taxonomy_levels
    bloom_levels.each do |bloom_level|
      bloom_level.update(percentage: rand(0..100))
    end
    activity_calification.complete! if activity_calification.state == "no_grade"
    activity_calification.update(numeric_grade: rand(1..5))
  end
end
