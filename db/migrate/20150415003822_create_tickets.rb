class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :sku, null: false
      t.integer :tier, null: false
      t.string :tier_name
      t.text :tier_description
      t.integer :price, null: false
      t.string :status, null: false
      t.belongs_to :event, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
