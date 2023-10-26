class AddCommentToBloomTaxonomyLevel < ActiveRecord::Migration[6.0]
  def change
    add_column :bloom_taxonomy_levels, :comment, :text
  end
end
