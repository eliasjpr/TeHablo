class AddRoleToUsersTable < ActiveRecord::Migration
	def self.up
		add_column :users, :roles, :string
		add_column :users, :commission_type, :string
	end


	def self.down
		remove_column :users, :roles
		remove_column :users, :commission_type
	end
end
