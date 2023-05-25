class CreateRotationTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :rotation_types do |t|
      t.string :description
      t.integer :credits
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
