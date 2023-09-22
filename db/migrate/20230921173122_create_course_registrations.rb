class CreateCourseRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :course_registrations do |t|
      t.references :student, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
