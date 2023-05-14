class CreateUserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name, limit: 100
      t.string :last_name, limit: 100
      t.string :telephone, limit: 30
      t.datetime :joined_at
      t.string :photo_url, limit: 200
      t.string :timezone, limit: 60
      t.json :settings

      t.timestamps
    end
  end
end
