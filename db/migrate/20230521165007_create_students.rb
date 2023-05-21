class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.references :user_profile, null: false, foreign_key: true
      t.string :semester
      t.string :id_number
      t.string :id_type

      t.timestamps
    end
  end
end
