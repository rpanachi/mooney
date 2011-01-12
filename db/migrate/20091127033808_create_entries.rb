class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.references :account
      t.date :date
      t.decimal :value, :precision => 10, :scale => 2
      t.string :description, :limit => 100
      t.boolean :paid, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
