class ChangeRubricDescriptionLimit < ActiveRecord::Migration[6.0]
  def change
    change_column :rubrics, :description, :string, limit: 500
  end
end
