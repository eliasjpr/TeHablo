class AddStripeCustomerIdToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :stripe_customer_id, :string
    add_column :users, :bank_account, :string
    add_column :users, :routing_number, :string
    add_column :users, :account_number, :string
    add_column :users, :tax_id, :string
    add_column :users, :stripe_recipient_id, :string
  end

  def self.down
    remove_column :users, :stripe_customer_id
    remove_column :users, :bank_account
    remove_column :users, :routing_number
    remove_column :users, :account_number
    remove_column :users, :tax_id
    remove_column :users, :stripe_recipient_id
  end
end
