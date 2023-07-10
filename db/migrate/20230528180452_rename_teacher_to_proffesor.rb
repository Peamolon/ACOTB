class RenameTeacherToProffesor < ActiveRecord::Migration[6.0]
  def change
    rename_table :teachers, :professors
  end
end
