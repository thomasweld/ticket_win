class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true

      t.timestamps null: false
    end

    add_column :tickets, :order_id, :integer, index: true
  end
end
