class AddIdNumberAndIdTypeToUserProfile < ActiveRecord::Migration[6.0]
  def up
    add_column :user_profiles, :id_type, :string
    add_column :user_profiles, :id_number, :string
  end

  def down
    remove_column :user_profiles, :id_type
    remove_column :user_profiles, :id_number
  end
end
