# == Schema Information
#
# Table name: academic_periods
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  number     :integer
#  start_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint           not null
#
# Indexes
#
#  index_academic_periods_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
class AcademicPeriod < ApplicationRecord
  belongs_to :subject
  has_many :unities
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :number, presence: true

  def self.closest_to_today
    where('start_date <= ? AND end_date >= ?', Date.current, Date.current).order(start_date: :asc).first
  end
end
