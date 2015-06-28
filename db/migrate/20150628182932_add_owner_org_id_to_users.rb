class AddOwnerOrgIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :owner_org_id, :integer, index: true
  end
end
