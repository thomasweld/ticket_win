class AddDeliveryEmailToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_email, :string
    add_index :orders, :redemption_code, unique: true
  end
end
