class AddSubjectToActivities < ActiveRecord::Migration[6.0]
  def change
    add_reference :activities, :subject, null: false, foreign_key: true
  end
end
