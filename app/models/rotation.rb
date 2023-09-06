# == Schema Information
#
# Table name: rotations
#
#  id             :bigint           not null, primary key
#  end_date       :date
#  name           :string
#  start_date     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  director_id    :bigint           not null
#  institution_id :bigint           not null
#  subject_id     :integer
#
# Indexes
#
#  index_rotations_on_director_id     (director_id)
#  index_rotations_on_institution_id  (institution_id)
#
# Foreign Keys
#
#  fk_rails_...  (director_id => directors.id)
#  fk_rails_...  (institution_id => institutions.id)
#
class Rotation < ApplicationRecord
  belongs_to :institution
  belongs_to :director

  validates :start_date, presence: true
  validates :end_date, presence: true

  def subject
    Subject.find(self.subject_id)
  end
end
