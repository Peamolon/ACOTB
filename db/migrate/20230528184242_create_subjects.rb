class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.integer :manager_id
      t.integer :total_credits
      t.integer :credits

      t.timestamps
    end
    add_index :subjects, :manager_id
  end
end
