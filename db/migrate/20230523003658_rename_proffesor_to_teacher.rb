class RenameProffesorToTeacher < ActiveRecord::Migration[6.0]
  def change
    rename_table :proffesors, :teachers
  end
end
