class AddBrandToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :charge_brand, :string
  end
end
