class StudentInformation < ApplicationRecord
  belongs_to :student
  belongs_to :rotation
end
