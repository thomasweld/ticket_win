class AddTierIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :tier_id, :integer
  end
end
