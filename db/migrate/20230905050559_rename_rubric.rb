class RenameRubric < ActiveRecord::Migration[6.0]
  def change
    rename_column :rubrics, :response, :description
    rename_column :rubrics, :name, :verb
  end
end
