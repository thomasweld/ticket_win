class RemoveEventIdAndTierFieldsFromTickets < ActiveRecord::Migration
  def change
    remove_column :tickets, :event_id, :integer
    remove_column :tickets, :tier, :integer
    remove_column :tickets, :tier_name, :string
    remove_column :tickets, :tier_description, :text
    remove_column :tickets, :price, :integer
  end
end
