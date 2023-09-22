class AddDeliveryDateToUnities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :delivery_date, :date
  end
end