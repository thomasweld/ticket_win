class AddDisplayToTiers < ActiveRecord::Migration
  def change
    add_column :tiers, :display, :boolean, default: true
  end
end
