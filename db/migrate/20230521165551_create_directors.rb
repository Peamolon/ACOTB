class CreateDirectors < ActiveRecord::Migration[6.0]
  def change
    create_table :directors do |t|
      t.references :user_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
