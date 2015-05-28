class AddFieldsToCallTable < ActiveRecord::Migration
  def self.up
    add_column :calls, :bill_duration, :integer, default: 0
    add_column :calls, :billed_duration, :decimal, default: 0.00, precision: 12, scale: 8
    add_column :calls, :api_id, :string
    add_column :calls, :agent_id, :integer
    add_column :users, :endpoint_id, :string
  end

  def self.down
    remove_column :calls, :bill_duration
    remove_column :calls, :billed_duration
    remove_column :calls, :api_id
    remove_column :calls, :agent_id
    remove_column :users, :endpoint_id
  end
end
