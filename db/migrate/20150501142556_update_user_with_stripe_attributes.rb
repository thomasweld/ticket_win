class UpdateUserWithStripeAttributes < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :stripe_user_id
      t.string :stripe_account_type
      t.string :stripe_pub_key
      t.string :stripe_secret_key
      t.datetime :stripe_authorized_at
    end
  end
end
