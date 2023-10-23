class RemoveDeliveryDateFromActivities < ActiveRecord::Migration[6.0]
  def change
    remove_column :activities, :delivery_date
  end
end
