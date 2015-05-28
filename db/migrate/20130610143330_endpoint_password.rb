class EndpointPassword < ActiveRecord::Migration
  def self.up
    add_column :users, :endpoint_password, :string
  end

  def self.down
    remove_column :users, :endpoint_password
  end
end
