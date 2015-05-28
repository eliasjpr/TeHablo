class AddTransferStatusToReceiptsTable < ActiveRecord::Migration
  def self.up
    add_column :receipts, :transfer_status, :string
    add_column :receipts, :transfer_fee, :string
    add_column :receipts, :transfer_id, :string
  end

  def self.down
    remove_column :receipts, :transfer_status
    remove_column :receipts, :transfer_fee
    remove_column :receipts, :transfer_id
  end
end
