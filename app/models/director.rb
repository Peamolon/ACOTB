class Director < ApplicationRecord
  belongs_to :user_profile
  has_many :subjects
end
