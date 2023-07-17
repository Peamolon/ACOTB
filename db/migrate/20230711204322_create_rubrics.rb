class CreateRubrics < ActiveRecord::Migration[6.0]
  def change
    create_table :rubrics do |t|
      t.string :name, limit: 200
      t.string :level, limit: 100
      t.string :response, limit: 200

      t.timestamps
    end
  end
end
