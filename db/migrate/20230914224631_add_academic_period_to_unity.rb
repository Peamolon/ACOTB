class AddAcademicPeriodToUnity < ActiveRecord::Migration[6.0]
  def change
    add_reference :unities, :academic_period, null: false, foreign_key: true
  end
end
