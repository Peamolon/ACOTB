class RolifyCreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:user_profiles_roles, :id => false) do |t|
      t.references :user_profile
      t.references :role
    end
    
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:user_profiles_roles, [ :user_profile_id, :role_id ])
  end
end
