class CreateStudentInformations < ActiveRecord::Migration[6.0]
  def change
    create_table :student_informations do |t|
      t.references :student, null: false, index: true, foreign_key: true
      t.references :rotation, null: false, index: true, foreign_key: true
      t.timestamp :start_at
      t.timestamp :end_at

      t.timestamps
    end
  end
end
