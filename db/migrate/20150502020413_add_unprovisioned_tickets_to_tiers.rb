class AddUnprovisionedTicketsToTiers < ActiveRecord::Migration
  def change
    add_column :tiers, :unprovisioned_tickets, :integer, default: 0
  end
end
