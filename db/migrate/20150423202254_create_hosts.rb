class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.integer :stripe_account_id
      t.string :first_name
      t.string :last_name
      t.string :legal_entity_type
      t.string :address
      t.datetime :birth_date
      t.integer :ssn_last_4
      t.datetime :stripe_tos_acceptance_date
      t.string :stripe_tos_acceptance_ip
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
