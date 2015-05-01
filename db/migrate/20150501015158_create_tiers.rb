class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.integer :level
      t.string :name
      t.text :description
      t.integer :price
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
