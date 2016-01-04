class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.belongs_to :order
      t.belongs_to :event
      t.integer :amount # in cents

      t.datetime :synced_at # uploaded to Talkable
      t.datetime :redeemed_at
      t.timestamps null: false
    end

    add_index :coupons, :code, unique: true
  end
end
