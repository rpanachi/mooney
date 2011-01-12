class AddCategoryInEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :category_id, :integer, :references => :users
    add_index :entries, :category_id
    add_index :entries, :user_id
  end

  def self.down
    remove_index :entries, :user_id
    remove_index :entries, :category_id
    remove_column :entries, :category_id
  end
end
