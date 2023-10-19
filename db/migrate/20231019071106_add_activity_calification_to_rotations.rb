class AddActivityCalificationToRotations < ActiveRecord::Migration[6.0]
  def change
    add_reference :activity_califications, :rotation, null: false, foreign_key: true
  end
end
