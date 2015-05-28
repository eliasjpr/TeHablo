class CreateRecharges < ActiveRecord::Migration
  def change
    create_table :recharges do |t|
      t.integer :user_id
      t.integer :agent_id
      t.integer :last4
      t.string :card_type
      t.boolean :paid, default: false
      t.decimal :amount, default: 0.00, precision: 12, scale: 8
      t.string :currency
      t.boolean :refunded, default: false
      t.decimal :fee, default: 0.00, precision: 12, scale: 8
      t.boolean :captured, default: false
      t.string :failure_message
      t.string :failure_code
      t.decimal :amount_refunded, default: 0.00, precision: 12, scale: 8
      t.string :customer
      t.string :invoice
      t.string :description
      t.string :dispute

      t.timestamps
    end
  end
end
