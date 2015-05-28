class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :user_id
      t.integer :agent_id
      t.decimal :amount, default: 0.00, precision: 12, scale: 8
      t.decimal :commission_earned, default: 0.00, precision: 12, scale: 8
      t.decimal :commission_rate, default: 0.00, precision: 12, scale: 8
      t.string :ip_address
      t.timestamps
    end
  end
end
