class CreateActivityCalifications < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_califications do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.float :numeric_grade
      t.text :notes
      t.date :calification_date
      t.text :bloom_taxonomy_percentage

      t.timestamps
    end
  end
end
