class AddProfessorToSubjects < ActiveRecord::Migration[6.0]
  def change
    add_reference :subjects, :professor, null: true, foreign_key: true
  end
end
