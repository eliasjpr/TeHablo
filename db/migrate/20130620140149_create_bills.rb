class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|

      t.integer :agent_id
      t.integer :user_id
      t.integer :service_id
      t.string :account_number
      t.string :phone
      t.decimal :amount
      t.decimal :convenience_fee
      t.string :status
      t.attachment :bill_preview
      t.timestamps
    end
  end
end
