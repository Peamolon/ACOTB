class FixActivitiesUnityReference < ActiveRecord::Migration[6.0]
  def change
    rename_column :activities, :unities_id, :unity_id
  end
end
