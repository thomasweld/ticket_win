class DropHostsTable < ActiveRecord::Migration
  def change
    drop_table :hosts
  end
end
