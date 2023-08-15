class CreateUnities < ActiveRecord::Migration[6.0]
  def change
    create_table :unities do |t|
      t.references :user_profiles, null: false, foreign_key: true, index: true
      t.string :type
      t.string :name, limit: 200

      t.timestamps
    end
  end
end
