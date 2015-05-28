class AddAttachmentLogoToAgents < ActiveRecord::Migration
	def self.up
		change_table :agents do |t|
			t.attachment :logo
		end
	end

	def self.down
		drop_attached_file :users, :logo
	end
end
