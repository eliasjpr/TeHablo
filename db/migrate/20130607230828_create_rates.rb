class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :direction
      t.string :country
      t.string :country_code
      t.string :country_iso
      t.integer :prefix
      t.decimal :voice_rate, default: 0.00, precision: 12, scale: 8
      t.string :unit_in_seconds
      t.string :number_type
      t.decimal :rent_per_number, default: 0.00, precision: 12, scale: 8
      t.decimal :setup_cost_per_number, default: 0.00, precision: 12, scale: 8
      t.string :country_iso_2
      t.timestamps
    end
  end
end
