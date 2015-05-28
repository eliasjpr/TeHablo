class CreateCallingIds < ActiveRecord::Migration
	def change
		create_table :calling_ids do |t|
			t.string :call_id
			t.integer :user_id

			t.timestamps
		end
	end
end
