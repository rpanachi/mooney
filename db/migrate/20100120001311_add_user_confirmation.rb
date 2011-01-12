class AddUserConfirmation < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :perishable_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    User.all.each do |user|
      user.reset_perishable_token
      user.confirmation_sent_at = user.created_at
      user.confirmed_at = Time.now
      user.save
      puts "-- confirming and activating user '#{user.email}'"
    end
  end

  def self.down
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :perishable_token
    remove_column :users, :name
  end
end
