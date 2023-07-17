class CreatePasswordResets < ActiveRecord::Migration[6.0]
  def change
    create_table :password_resets do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.string :password, limit: 10
      t.string :code, limit: 30
      t.boolean :is_used
      t.timestamp :requested_at
      t.string :ip_address, limit: 60

      t.timestamps
    end
  end
end
