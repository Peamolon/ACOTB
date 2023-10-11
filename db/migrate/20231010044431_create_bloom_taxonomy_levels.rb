class CreateBloomTaxonomyLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :bloom_taxonomy_levels do |t|
      t.integer :level
      t.integer :percentage
      t.string :verb
      t.references :activity_calification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
