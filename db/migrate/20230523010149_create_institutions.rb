class CreateInstitutions < ActiveRecord::Migration[6.0]
  def change
    create_table :institutions do |t|
      t.references :manager, null: false, foreign_key: true
      t.string :name
      t.string :code, limit: 32
      t.string :contact_email, limit: 128
      t.string :contact_telephone, limit: 30

      t.timestamps
    end
  end
end
