class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :call_duration, default: 0
      t.decimal :total_amount, default: 0.00, precision: 12, scale: 8
      t.string :parent_call_uuid
      t.string :call_uuid
      t.string :call_direction
      t.string :to_number
      t.decimal :total_rate, default: 0.00, precision: 12, scale: 8
      t.string :from_number
      t.datetime :end_time
      t.string :resource_uri
      t.string :call_status
      t.integer :user_id
      t.timestamps
    end
  end
end