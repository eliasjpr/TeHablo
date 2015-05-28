class RenameAgentToUser < ActiveRecord::Migration
	def self.up
		rename_table :agents, :users
	end

	def self.down
		rename_table :users, :agents
	end
end
