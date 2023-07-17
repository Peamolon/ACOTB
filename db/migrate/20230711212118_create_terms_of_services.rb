class CreateTermsOfServices < ActiveRecord::Migration[6.0]
  def change
    create_table :terms_of_services do |t|
      t.string :body
      t.string :version, limit: 10
      t.timestamp :publish_at

      t.timestamps
    end
  end
end
