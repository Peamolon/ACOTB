class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :unities, null: false, foreign_key: true, index: true
      t.string :type
      t.string :name, limit: 200

      t.timestamps
    end
  end
end
