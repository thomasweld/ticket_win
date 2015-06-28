class AddOrganizationIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :organization_id, :integer, index: true
  end
end
