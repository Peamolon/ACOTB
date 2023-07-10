class Subject < ApplicationRecord
  belongs_to :director, foreign_key: 'director_id', class_name: 'Director'
end
