class CreateManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :managers do |t|
      t.references :user_profile, null: false, foreign_key: true
      t.string :position

      t.timestamps
    end
  end
end
