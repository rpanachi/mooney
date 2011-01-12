class AddMissingsIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :email, {:unique => true}
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    add_index :categories, :user_id
  end

  def self.down
    remove_index :categories, :user_id
    remove_index :users, :last_request_at
    remove_index :users, :persistence_token
    remove_index :users, :email
  end
end
