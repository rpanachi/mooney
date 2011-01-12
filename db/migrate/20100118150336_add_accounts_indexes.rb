class AddAccountsIndexes < ActiveRecord::Migration
  def self.up
    add_index :accounts, :user_id
  end

  def self.down
    remove_index :accounts, :user_id
  end
end
