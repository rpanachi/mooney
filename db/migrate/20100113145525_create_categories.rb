class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :user_id, :references => :users
      t.integer :parent_id, :null => false, :default => 0
      t.integer :position
      t.string :name
      t.timestamps
    end
    add_index(:categories, :parent_id)
  end

  def self.down
    drop_table :categories
  end
end
