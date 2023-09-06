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
  #validates :semester, inclusion: { in: %w(1 2 3 4 5 6 7 8 9 10 11 12) }
  #validates :id_type, :id_number, presence: true
  #validate :valid_document_type

  ALLOWED_DOCUMENT_TYPES = %w[cc identify_card foreigner_id]

  private

  def valid_document_type
    unless ALLOWED_DOCUMENT_TYPES.include?(id_type)
      errors.add(:id_type, 'is not valid')
    end
  end
end
