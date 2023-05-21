class CreateProffesors < ActiveRecord::Migration[6.0]
  def change
    create_table :proffesors do |t|
      t.references :user_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
