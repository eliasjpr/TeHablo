class CreateAgents < ActiveRecord::Migration
	def change
		create_table :agents do |t|
			t.string :first_name
			t.string :last_name
			t.string :email
			t.string :logo
			t.string :business_name
			t.decimal :balance, default: 0.00, precision: 12, scale: 8
			t.decimal :commission, default: 0.00, precision: 12, scale: 8
			t.boolean :account_status
			t.string :sid
			t.string :auth_token

			t.timestamps
		end
	end
end