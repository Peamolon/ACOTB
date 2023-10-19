class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.references :professor, null: false, foreign_key: true
      t.integer :total_credits
      t.integer :credits

      t.timestamps
    end
  end
end
