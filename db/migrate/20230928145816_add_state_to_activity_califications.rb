class AddStateToActivityCalifications < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_califications, :state, :string
  end
end
