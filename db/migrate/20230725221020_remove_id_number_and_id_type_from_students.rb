class RemoveIdNumberAndIdTypeFromStudents < ActiveRecord::Migration[6.0]

  def up
    remove_column :students, :id_type
    remove_column :students, :id_number

  end

  def down
    add_column :students, :id_type, :string
    add_column :students, :id_number, :string
  end
end
