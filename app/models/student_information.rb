class StudentInformation < ApplicationRecord
  belongs_to :student
  belongs_to :rotation

  validates :start_date, presence: true

end
