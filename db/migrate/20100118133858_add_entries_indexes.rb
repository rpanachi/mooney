class AddEntriesIndexes < ActiveRecord::Migration
  def self.up
    add_index :entries, :account_id
    add_index :entries, :date
    add_index :entries, :value
    add_index :entries, :paid
  end

  def self.down
    remove_index :entries, :paid
    remove_index :entries, :value
    remove_index :entries, :date
    remove_index :entries, :account_id
  end
end
