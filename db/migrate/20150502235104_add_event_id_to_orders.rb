class AddEventIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :event_id, :integer, index: true
  end
end
