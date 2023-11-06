class AddrotationGradeToRotations < ActiveRecord::Migration[6.0]
  def change
    add_column :rotations, :numeric_grade, :float
  end
end
