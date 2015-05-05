class AddRedemptionCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :redemption_code, :string
  end
end
