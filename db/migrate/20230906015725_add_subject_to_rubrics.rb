class AddSubjectToRubrics < ActiveRecord::Migration[6.0]
  def change
    add_reference :rubrics, :subject, foreign_key: true
  end
end
