class CreateRubrics < ActiveRecord::Migration[6.0]
  def change
    create_table :rubrics do |t|
      t.string :verb, limit: 200
      t.string :level, limit: 100
      t.string :description

      t.timestamps
    end
  end
end
