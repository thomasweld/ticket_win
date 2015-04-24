class AddHostEnabledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :host_enabled, :boolean, default: true
  end
end
