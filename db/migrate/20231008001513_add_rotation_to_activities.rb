class AddRotationToActivities < ActiveRecord::Migration[6.0]
  def change
    add_reference :activities, :rotation, null: false, foreign_key: true
  end
end
