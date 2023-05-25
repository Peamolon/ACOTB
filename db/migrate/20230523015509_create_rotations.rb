class CreateRotations < ActiveRecord::Migration[6.0]
  def change
    create_table :rotations do |t|
      t.references :rotation_type, null: false, foreign_key: true
      t.references :institution, null: false, foreign_key: true
      t.references :director, null: false, foreign_key: true
      t.string :name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
