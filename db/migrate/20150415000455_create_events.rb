class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
