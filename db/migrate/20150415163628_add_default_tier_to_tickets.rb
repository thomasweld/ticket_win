class AddDefaultTierToTickets < ActiveRecord::Migration
  def change
    change_column :tickets, :tier, :integer, default: 1
    change_column :tickets, :price, :integer, default: 0
  end
end
