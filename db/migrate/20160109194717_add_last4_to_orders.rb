class AddLast4ToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :last4, :string
  end
end
