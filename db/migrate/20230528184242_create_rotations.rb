class CreateRotations < ActiveRecord::Migration[6.0]
  def change
    create_table :rotations do |t|
      t.references :institution, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
