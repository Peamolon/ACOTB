class AddAcademicPeriodToRotations < ActiveRecord::Migration[6.0]
  def change
    add_reference :rotations, :academic_period, null: false, foreign_key: true
  end
end
