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
class Student < ApplicationRecord
  belongs_to :user_profile
  has_many :activity_califications
  has_many :activities, through: :activity_califications
  has_many :course_registrations
  has_many :student_informations
  has_many :rotations, through: :student_informations
  has_many :subjects, through: :rotations
  #validates :semester, inclusion: { in: %w(1 2 3 4 5 6 7 8 9 10 11 12) }
  #validates :id_type, :id_number, presence: true
  #validate :valid_document_type

  ALLOWED_DOCUMENT_TYPES = %w[cc identify_card foreigner_id]

  def full_name
    "#{user_profile.first_name} #{user_profile.last_name}"
  end

  def telephone
    user_profile.telephone
  end

  def id_number
    user_profile.id_number
  end

  def id_type
    user_profile.id_type
  end

  def average_bloom_taxonomy_percentage
    all_califications = activity_califications

    average_bloom_taxonomy = {
      1 => 0,
      2 => 0,
      3 => 0,
      4 => 0,
      5 => 0,
      6 => 0
    }

    all_califications.each do |calification|
      calification.bloom_taxonomy_percentage.each do |category, percentage|
        average_bloom_taxonomy[category] += percentage
      end
    end

    total_records = all_califications.size.to_f
    average_bloom_taxonomy.transform_values! { |sum| (sum / total_records).round(1) }

    average_bloom_taxonomy
  end

  def as_json(options = {})
    super(options.merge(methods: [:full_name, :telephone, :id_number, :id_type]))
  end

  private
  def valid_document_type
    unless ALLOWED_DOCUMENT_TYPES.include?(id_type)
      errors.add(:id_type, 'is not valid')
    end
  end
end
