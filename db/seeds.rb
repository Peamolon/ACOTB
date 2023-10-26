#Creating users
=begin
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
=end
#Creates default user

user_params = {
  first_name: 'Sergio',
  last_name: 'Peña',
  telephone: "3227755151",
  role: 'student',
  email: 'spenaa@unbosque.edu.co',
  username: 'student',
  id_number: '1007351989',
  id_type: "CC",
  joined_at: Date.today
}

service = ::Users::UserProfileCreatorService.new(user_params)
service.call

user_params = {
  first_name: 'Juan',
  last_name: 'Peña',
  telephone: "3209357918",
  role: 'professor',
  email: 'jcpenap@unbosque.edu.co',
  username: 'professor',
  id_number: '1004351989',
  id_type: "CC",
  joined_at: Date.today
}

service = ::Users::UserProfileCreatorService.new(user_params)
service.call

user_params = {
  first_name: 'Briannys',
  last_name: 'Paez',
  telephone: "3209357918",
  role: 'professor',
  email: 'bpaezm@unbosque.edu.co',
  username: 'professor',
  id_number: '1004351989',
  id_type: "CC",
  joined_at: Date.today
}

service = ::Users::UserProfileCreatorService.new(user_params)
service.call

user_params = {
  first_name: 'Juanito',
  last_name: 'Paez',
  telephone: "3209357418",
  role: 'manager',
  email: 'manager@unbosque.edu.co',
  username: 'manager',
  id_number: '1004351989',
  id_type: "CC",
  joined_at: Date.today
}

service = ::Users::UserProfileCreatorService.new(user_params)
service.call



names =["Hospital Universitario Centro Dermatologico Federico Lleras Acosta E.S.E","CENTRO MEDICO IMBANACO DE CALI ","SOMA","HOSPITAL NAVAL CARTAGENA ","IDIME ","SUBRED INTEGRADA DE SERVICIOS DE SALUD NORTE ","SUBRED INTEGRADA DE SERVICIOS DE SALUD SUROCCIDENTE ","SUBRED INTEGRADA DE SERVICIOS DE SALUD CENTROORIENTE ","CLINICA VASCULAR NAVARRA ","UNIVERSIDAD DEL NORTE ","CLINICOS IPS ","CAFAM"]


#Creating Institutions
names.each do |name|
  institution_params = {
    name: name,
    code: 'code',
    contact_email: Faker::Internet.email,
    contact_telephone: Faker::PhoneNumber.cell_phone,
    manager_id: User.find_by(username: 'manager').manager.id
  }

  Institution.create!(institution_params)
end

#Creating Subjects
subject_params = {
  name: 'Semiología',
  credits: 5,
  manager_id: User.find_by(username: 'manager').manager.id,
  professor_id: User.find_by(username: 'professor').professor.id,
  academic_period_info: [
    {
      start_date: '10/07/2023',
      end_date: '15/08/2023'
    },
    {
      start_date: '15/08/2023',
      end_date: '01/10/2023'
    },
    {
      start_date: '01/10/2023',
      end_date: '05/12/2023'
    }
  ],
  rubric_info: [
    {
      verb: 'Recordar',
      description: 'Recordar y nombrar los principios fundamentales de la semiología, como los métodos de diagnóstico, la interpretación de signos y síntomas, y la terminología médica. Además, reconocer la importancia de la semiología en la práctica médica y su papel en el diagnóstico de enfermedades.'
    },
    {
      verb: 'Comprender',
      description: 'Comprender y explicar los conceptos clave de la semiología médica, incluyendo la fisiopatología de las enfermedades y los procesos de diagnóstico. Asimismo, relacionar los hallazgos semiológicos con las enfermedades subyacentes y comprender la relevancia de la semiología en la toma de decisiones clínicas.'
    },
    {
      verb: 'Aplicar',
      description: 'Aplicar las habilidades de semiología en un entorno clínico real, realizar exámenes físicos, tomar historias clínicas y elaborar diagnósticos basados en hallazgos. Realizar procedimientos semiológicos de manera efectiva y segura, aplicando técnicas avanzadas y protocolos de atención al paciente.'
    },
    {
      verb: 'Analizar',
      description: 'Analizar casos clínicos complejos, interpretar hallazgos semiológicos y correlacionarlos con diagnósticos diferenciales y planes de tratamiento. Evaluar críticamente la información semiológica y aplicarla en la toma de decisiones médicas. También, analizar la evidencia científica relevante.'
    },
    {
      verb: 'Evaluar',
      description: 'Evaluar el rendimiento propio y el de los compañeros en la práctica de la semiología, participar en discusiones clínicas y evaluar la calidad de los diagnósticos realizados. Proporcionar retroalimentación constructiva y contribuir al desarrollo profesional. Además, evaluar la efectividad de las estrategias diagnósticas aplicadas.'
    },
    {
      verb: 'Crear',
      description: 'Crear informes médicos detallados, proponer investigaciones sobre métodos semiológicos avanzados y contribuir al avance de la semiología médica. Desarrollar nuevas formas de aplicar la semiología en la medicina moderna, generando conocimiento innovador y mejorando la calidad de la atención médica.'
    }
  ]
}

::Subjects::CreateSubjectService.new(subject_params).call

#Corte 1

module_data = [
  {
    name: 'Semiología Médica',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Oftalmológica',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Radiológica',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Neurológica',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Cardiovascular',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Gastrointestinal',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Respiratoria',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Otorrinolaringológica',
    type: Unity::UNITY_TYPES.sample,
    academic_period_id: Subject.last.academic_periods.find_by(number: 1).id,
    subject_id: Subject.last.id
  }
]
ActiveRecord::Base.transaction do
  module_data.each do |data|
    Unity.create(data)
  end
end

activity_data = [
  {
    module_name: 'Semiología Médica',
    name: 'Identificar signos vitales y registrarlos en una ficha médica',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['APLICAR', 'EVALUAR']
  },
  {
    module_name: 'Semiología Médica',
    name: 'Comparar y contrastar diferentes métodos de diagnóstico',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Médica',
    name: 'Realizar un debate sobre la importancia de la semiología médica',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR', 'CREAR']
  },
  {
    module_name: 'Semiología Médica',
    name: 'Realizar un examen práctico en pacientes simulados',
    type: 'PRACTICAL',
    unity_id: nil,
    bloom_data: ['APLICAR']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Realizar un examen completo del fondo de ojo',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['APLICAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Describir las diferencias entre enfermedades oftalmológicas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Interpretar resultados de exámenes oftalmológicos',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Realizar pruebas de agudeza visual en pacientes y documentar',
    type: 'PRACTICAL',
    unity_id: nil,
    bloom_data: ['APLICAR', 'CREAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Interpretar radiografías y detectar anomalías, elaborando informes',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR', 'EVALUAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Evaluar la calidad de las imágenes radiológicas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR', 'CREAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Redactar informes radiológicos para casos específicos proporcionados',
    type: 'PRACTICAL',
    unity_id: nil,
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Presentar estudios de casos de radiología a los compañeros',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Realizar una exploración detallada del sistema nervioso en pacientes virtuales',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['APLICAR', 'COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Evaluar y diagnosticar trastornos neurológicos basados en historias clínicas y pruebas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Comparar y contrastar diferentes pruebas neurológicas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Preparar y presentar casos neurológicos con hallazgos y diagnósticos',
    type: 'PRACTICAL',
    unity_id: nil,
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Cardiovascular',
    name: 'Evaluar pacientes con enfermedades cardíacas mediante pruebas diagnósticas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR', 'ANALIZAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Cardiovascular',
    name: 'Analizar pruebas cardíacas y correlacionar los resultados con diagnósticos clínicos',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR', 'EVALUAR']
  },
  {
    module_name: 'Semiología Cardiovascular',
    name: 'Realizar una exploración física cardiológica completa y documentar los hallazgos',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['APLICAR']
  },
  {
    module_name: 'Semiología Gastrointestinal',
    name: 'Identificar trastornos gastrointestinales en pacientes virtuales y proponer diagnósticos',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Gastrointestinal',
    name: 'Interpretar resultados de endoscopias y explicar las observaciones clínicas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Gastrointestinal',
    name: 'Evaluar pacientes con enfermedades gastrointestinales y justificar el enfoque diagnóstico',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR']
  },
  {
    module_name: 'Semiología Respiratoria',
    name: 'Evaluar pacientes con enfermedades respiratorias crónicas, recomendando tratamientos',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR', 'COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Respiratoria',
    name: 'Realizar pruebas de función pulmonar y analizar los resultados',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['APLICAR', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Respiratoria',
    name: 'Interpretar radiografías torácicas y describir las anomalías observadas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Otorrinolaringológica',
    name: 'Realizar un examen detallado de oído, nariz y garganta en pacientes virtuales',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['APLICAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Otorrinolaringológica',
    name: 'Identificar trastornos auditivos en pacientes simulados y describir sus características',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Otorrinolaringológica',
    name: 'Diagnosticar enfermedades otorrinolaringológicas basadas en historias clínicas y pruebas',
    type: 'THEORETICAL',
    unity_id: nil,
    bloom_data: ['EVALUAR']
  },
]

BLOOM_LEVELS = {
  "RECORDAR" => 0,
  "COMPRENDER" => 1,
  "APLICAR" => 2,
  "ANALIZAR" => 3,
  "EVALUAR" => 4,
  "CREAR" => 5
}.freeze


ActiveRecord::Base.transaction do
  activity_data.each do |data|
    module_id = Unity.find_by(name: data[:module_name]).id

    activity = Activity.create!(
      name: data[:name],
      type: data[:type],
      unity_id: module_id,
      bloom_taxonomy_levels: data[:bloom_data]
    )
  end
end







#---------------CORTE 2-----------------

academic_period_2 = Subject.last.academic_periods.find_by(number: 2).id

unity_data = [
  {
    name: 'Semiología Médica',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Oftalmológica',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Radiológica',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Neurológica',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Cardiovascular',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Gastrointestinal',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Respiratoria',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  },
  {
    name: 'Semiología Otorrinolaringológica',
    type: 'MODULE',
    academic_period_id: academic_period_2,
    subject_id: Subject.last.id
  }
]
ActiveRecord::Base.transaction do
  unity_data.each do |data|
    Unity.create(data)
  end
end



activity_data = [
  {
    module_name: 'Semiología Médica',
    name: 'Analizar electrocardiogramas y correlacionar con diagnósticos clínicos',
    type: 'PRACTICAL',
    bloom_data: ['APLICAR', 'ANALIZAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Médica',
    name: 'Realizar un examen práctico de diagnóstico en pacientes simulados',
    type: 'PRACTICAL',
    bloom_data: ['APLICAR']
  },
  {
    module_name: 'Semiología Médica',
    name: 'Evaluar pacientes con trastornos médicos diversos',
    type: 'THEORETICAL',
    bloom_data: ['EVALUAR', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Médica',
    name: 'Presentar casos clínicos y diagnósticos a los compañeros',
    type: 'THEORETICAL',
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Realizar un examen detallado del segmento anterior del ojo',
    type: 'PRACTICAL',
    bloom_data: ['APLICAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Interpretar resultados de pruebas oftalmológicas',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Realizar un examen práctico de oftalmoscopía',
    type: 'PRACTICAL',
    bloom_data: ['APLICAR']
  },
  {
    module_name: 'Semiología Oftalmológica',
    name: 'Comparar diferentes enfermedades oftalmológicas',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Interpretar radiografías y detectar anomalías',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR', 'EVALUAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Evaluar la calidad de las imágenes radiológicas',
    type: 'THEORETICAL',
    bloom_data: ['EVALUAR', 'CREAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Redactar informes radiológicos para casos específicos proporcionados',
    type: 'PRACTICAL',
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Radiológica',
    name: 'Presentar estudios de casos de radiología a los compañeros',
    type: 'THEORETICAL',
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Evaluar pacientes con trastornos neurológicos basados en historias clínicas y pruebas',
    type: 'THEORETICAL',
    bloom_data: ['EVALUAR', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Comparar y contrastar diferentes pruebas neurológicas',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Neurológica',
    name: 'Preparar y presentar casos neurológicos con hallazgos y diagnósticos',
    type: 'PRACTICAL',
    bloom_data: ['CREAR']
  },
  {
    module_name: 'Semiología Cardiovascular',
    name: 'Realizar una exploración física cardiológica completa y documentar los hallazgos',
    type: 'PRACTICAL',
    bloom_data: ['APLICAR']
  },
  {
    module_name: 'Semiología Cardiovascular',
    name: 'Evaluar pacientes con enfermedades cardíacas mediante pruebas diagnósticas',
    type: 'THEORETICAL',
    bloom_data: ['EVALUAR', 'ANALIZAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Cardiovascular',
    name: 'Analizar pruebas cardíacas y correlacionar los resultados con diagnósticos clínicos',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR', 'EVALUAR']
  },
  {
    module_name: 'Semiología Gastrointestinal',
    name: 'Identificar trastornos gastrointestinales en pacientes virtuales y proponer diagnósticos',
    type: 'THEORETICAL',
    bloom_data: ['COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Gastrointestinal',
    name: 'Interpretar resultados de endoscopias y explicar las observaciones clínicas',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Gastrointestinal',
    name: 'Evaluar pacientes con enfermedades gastrointestinales y justificar el enfoque diagnóstico',
    type: 'THEORETICAL',
    bloom_data: ['EVALUAR']
  },
  {
    module_name: 'Semiología Respiratoria',
    name: 'Evaluar pacientes con enfermedades respiratorias crónicas, recomendando tratamientos',
    type: 'THEORETICAL',
    bloom_data: ['EVALUAR', 'COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Respiratoria',
    name: 'Realizar pruebas de función pulmonar y analizar los resultados',
    type: 'THEORETICAL',
    bloom_data: ['APLICAR', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Respiratoria',
    name: 'Interpretar radiografías torácicas y describir las anomalías observadas',
    type: 'THEORETICAL',
    bloom_data: ['ANALIZAR']
  },
  {
    module_name: 'Semiología Otorrinolaringológica',
    name: 'Realizar un examen detallado de oído, nariz y garganta en pacientes virtuales',
    type: 'PRACTICAL',
    bloom_data: ['APLICAR', 'COMPRENDER']
  },
  {
    module_name: 'Semiología Otorrinolaringológica',
    name: 'Identificar trastornos auditivos en pacientes simulados y describir sus características',
    type: 'THEORETICAL',
    bloom_data: ['COMPRENDER', 'ANALIZAR']
  },
  {
    module_name: 'Semiología Otorrinolaringológica',
    name: 'Diagnosticar enfermedades otorrinolaringológicas basadas en historias clínicas y pruebas',
    type: 'PRACTICAL',
    bloom_data: ['EVALUAR']
  }
]

ActiveRecord::Base.transaction do
  activity_data.each do |activity_params|
    module_id = Unity.joins(:academic_period).where(name: activity_params[:module_name]).where(academic_periods: {number: 2 }).last.id
    activity_params[:unity_id] = module_id
    activity = Activity.create(
      name: activity_params[:name],
      type: activity_params[:type],
      unity_id: module_id,
      bloom_taxonomy_levels: activity_params[:bloom_data]
    )
  end
end

#corte 3 ------------------------------------------


modules_and_activities = [
  {
    name: "Semiología Médica",
    start_date: '04/10/2023',
    end_date: '18/10/2023',
    type: "MODULE",
    activities: [
      {
        name: "Análisis de la función del sistema digestivo en pacientes virtuales",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[1..4]
      },
      {
        name: "Evaluar pacientes con trastornos del tránsito intestinal",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      },
      {
        name: "Realizar pruebas de apoyo diagnóstico en trastornos del tránsito intestinal",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[2..4]
      }
    ]
  },
  {
    name: "Semiología Otorrinaringológica",
    start_date: '07/10/2023',
    end_date: '21/10/2023',
    type: "MODULE",
    activities: [
      {
        name: "Realizar un examen completo relacionado con nariz, cavidad oral, faringe y laringe en pacientes virtuales",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[2..3]
      },
      {
        name: "Identificar motivos de consulta relacionados con el oído",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[1]
      },
      {
        name: "Diagnosticar enfermedades otorrinaringológicas basadas en historias clínicas y pruebas",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      }
    ]
  },
  {
    name: "Semiología Cardiovascular",
    start_date: '14/10/2023',
    end_date: '28/10/2023',
    type: "MODULE",
    activities: [
      {
        name: "Evaluar pacientes con enfermedades cardíacas mediante pruebas diagnósticas",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[4..5]
      },
      {
        name: "Analizar pruebas cardíacas y correlacionar los resultados con diagnósticos clínicos",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      },
      {
        name: "Realizar una exploración física cardiológica completa y documentar los hallazgos",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[2]
      }
    ]
  },
  {
    name: "Semiología Gastrointestinal",
    start_date: '21/10/2023',
    end_date: '04/11/2023',
    type: "MODULE",
    activities: [
      {
        name: "Identificar trastornos gastrointestinales en pacientes virtuales y proponer diagnósticos",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[1..4]
      },
      {
        name: "Interpretar resultados de endoscopias y explicar las observaciones clínicas",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      },
      {
        name: "Evaluar pacientes con enfermedades gastrointestinales y justificar el enfoque diagnóstico",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[4]
      }
    ]
  },
  {
    name: "Semiología Respiratoria",
    start_date: '28/10/2023',
    end_date: '11/11/2023',
    type: "MODULE",
    activities: [
      {
        name: "Evaluar pacientes con enfermedades respiratorias crónicas, recomendando tratamientos",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[4..5]
      },
      {
        name: "Realizar pruebas de función pulmonar y analizar los resultados",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[2..4]
      },
      {
        name: "Interpretar radiografías torácicas y describir las anomalías observadas",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      }
    ]
  },
  {
    name: "Semiología Oftalmológica",
    start_date: '04/11/2023',
    end_date: '18/11/2023',
    type: "MODULE",
    activities: [
      {
        name: "Realizar un examen completo del fondo de ojo en pacientes virtuales",
        activity_type: "PRACTICAL",
        bloom_levels: BLOOM_LEVELS[2..3]
      },
      {
        name: "Describir las diferencias entre enfermedades oftalmológicas",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[3]
      },
      {
        name: "Interpretar resultados de exámenes oftalmológicos",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[3]
      }
    ]
  },
  {
    name: "Semiología Radiológica",
    start_date: '18/11/2023',
    end_date: '02/12/2023',
    type: "MODULE",
    activities: [
      {
        name: "Interpretar radiografías y detectar anomalías, elaborando informes",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      },
      {
        name: "Evaluar la calidad de las imágenes radiológicas",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[4..5]
      },
      {
        name: "Redactar informes radiológicos para casos específicos proporcionados",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[5]
      }
    ]
  },
  {
    name: "Semiología Nefrourológica",
    start_date: '02/12/2023',
    end_date: '05/12/2023',
    type: "MODULE",
    activities: [
      {
        name: "Evaluar pacientes con anuria, hematuria, proteinuria, oliguria y disuria",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[4..5]
      },
      {
        name: "Diagnosticar infecciones de vías urinarias en pacientes virtuales",
        activity_type: "THEORETICAL_PRACTICAL",
        bloom_levels: BLOOM_LEVELS[3..4]
      },
      {
        name: "Identificar síndromes nefrourológicos y correlacionar con resultados de exámenes",
        activity_type: "THEORETICAL",
        bloom_levels: BLOOM_LEVELS[3]
      }
    ]
  },
]

academic_period_3 = Subject.last.academic_periods.find_by(number: 3).id


ActiveRecord::Base.transaction do
  modules_and_activities.each do |module_data|
    unity = Unity.create(
      name: module_data[:name],
      type: module_data[:type],
      academic_period_id: academic_period_3,
      subject_id: Subject.last.id
    )

    module_data[:activities].each do |activity_data|
      activity = Activity.create(
        name: activity_data[:name],
        type: activity_data[:activity_type],
        unity_id: unity.id,
        bloom_taxonomy_levels: activity_data[:bloom_levels]
      )
    end
  end
end



student_id = User.find_by(username: 'student').user_profile.student.id
start_date = Date.new(2023, 7, 10)
end_date = Date.new(2023, 12, 5)
institutions = Institution.all.sample(7)
semiologia_subject = Subject.find_by(name: "Semiología")

if student_id
  unities = semiologia_subject.unities.includes(:academic_period).order('academic_periods.start_date')
  unities.each do |unity|
    start_period = unity.academic_period.start_date
    end_period = unity.academic_period.end_date
    (start_period.to_date..end_period.to_date).select { |date| date.wday.between?(1, 5) }.each do |week_start|
      week_end = week_start + 4.days
      current_period = AcademicPeriod.where(subject_id: semiologia_subject.id).find { |period| period.start_date <= week_start && period.end_date >= week_start }


      unity = Unity.joins(:academic_period).where(academic_periods: {number: current_period.number}).sample
      institution = Institution.all.sample
      next unless unity.present?

      selected_activities = unity.activities

      next unless selected_activities.present?

      rotation_params = {
        student_id: student_id,
        subject_id: semiologia_subject.id,
        institution_id: institution.id,
        start_date: week_start,
        end_date: week_end,
        activities_ids: selected_activities.pluck(:id)
      }
      rotation_service = Rotations::AssignRotationService.new(rotation_params).call
    end
  end
end;nil

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
