class RemoveHostEnabledFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :host_enabled, :boolean
  end
end
