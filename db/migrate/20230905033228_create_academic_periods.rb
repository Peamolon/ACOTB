class CreateAcademicPeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :academic_periods do |t|
      t.timestamp :start_date
      t.timestamp :end_date
      t.integer :number
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
