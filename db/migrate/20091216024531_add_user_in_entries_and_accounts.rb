class AddUserInEntriesAndAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :user_id, :integer, :references => :users
    add_column :entries, :user_id, :integer, :references => :users
  end

  def self.down
    remove_column :entries, :user_id
    remove_column :accounts, :user_id
  end
end
