class ChangeSubjectAssociationToRotation < ActiveRecord::Migration[6.0]
  def change
    remove_column :subjects, :manager_id
    add_reference :subjects, :rotation, foreign_key: true
  end
end
