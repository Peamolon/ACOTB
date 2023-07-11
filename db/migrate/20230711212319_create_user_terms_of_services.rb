class CreateUserTermsOfServices < ActiveRecord::Migration[6.0]
  def change
    create_table :user_terms_of_services do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :term_of_service, null: false, index: true, foreign_key: true
      t.timestamp :accept_at
      t.string :ip_address, limit: 60

      t.timestamps
    end
  end
end
