class AddsStateToRotations < ActiveRecord::Migration[6.0]
  def up
    add_column :rotations, :state, :string
  end

  def down
    remove_column :rotations, :state
  end
end
