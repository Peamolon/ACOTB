class CreateRubricRotationScores < ActiveRecord::Migration[6.0]
  def change
    create_table :rubric_rotation_scores do |t|
      t.references :rotation, null: false, index: true, foreign_key: true
      t.references :rubric, null: false, index: true, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
