class ChangeRotationManager < ActiveRecord::Migration[6.0]
  def change
    change_table :rotations do |t|
      t.remove_references :director, index: true, foreign_key: true
      t.references :manager, foreign_key: { to_table: :managers }
    end

  end
end
