# == Schema Information
#
# Table name: rubrics
#
#  id          :bigint           not null, primary key
#  description :string(200)
#  level       :string(100)
#  verb        :string(200)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  subject_id  :bigint
#
# Indexes
#
#  index_rubrics_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
class Rubric < ApplicationRecord
  belongs_to :subject

  validates :verb, presence: true
  validates :level, presence: true
  validates :description, presence: true

  validate :verb_is_valid

  LEVELS = %w[Recordar Comprender Aplicar Analizar Evaluar Crear]
  public_constant :LEVELS

  def keywords
    Rubric.keywords_for_verb_and_level(verb)
  end

  def self.keywords_for_verb(verb)
    keywords = {
      "Recordar" => %w[Definir Enumerar Identificar Nombrar Repetir Señalar Describir Enumerar Mencionar Recitar],
      "Comprender" => %w[Comprender Explicar Interpretar Resumir Contrastar Deducir Describir Dibujar Ilustrar Parafrasear],
      "Aplicar" => %w[Aplicar Calcular Demostrar Dibujar Implementar Modificar Operar Practicar Realizar Usar],
      "Analizar" => %w[Analizar Comparar Contrastar Descomponer Detectar Diseccionar Discriminar Dividir Evaluar Inferir],
      "Evaluar" => %w[Argumentar Calificar Censurar Comparar Contrastar Criticar Decidir Evaluar Juzgar Seleccionar],
      "Crear" => %w[Combinar Componer Construir Crear Diseñar Elaborar Formular Generar Organizar Planificar]
    }

    keywords[verb] || []
  end

  private
  def verb_is_valid
    unless LEVELS.include?(verb)
      errors.add(:verb, "must be one of the following: #{LEVELS.join(', ')}")
    end
  end
end
