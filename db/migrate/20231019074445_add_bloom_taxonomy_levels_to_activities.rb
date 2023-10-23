class AddBloomTaxonomyLevelsToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :bloom_taxonomy_levels, :string, array: true, default: []
  end
end
