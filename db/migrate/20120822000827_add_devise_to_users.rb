class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|

      ## Database authenticatable
      #t.string :email,              :null => false, :default => ""
      #t.string :encrypted_password, :null => false, :default => ""
      rename_column :users, :crypted_password, :encrypted_password

      ## Recoverable
      #t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      remove_index  :users, :persistence_token
      rename_column :users, :persistence_token, :reset_password_token

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      #t.integer  :sign_in_count, :default => 0
      #t.datetime :current_sign_in_at
      #t.datetime :last_sign_in_at
      #t.string   :current_sign_in_ip
      #t.string   :last_sign_in_ip
      rename_column :users, :login_count, :sign_in_count
      rename_column :users, :current_login_at, :current_sign_in_at
      rename_column :users, :last_login_at, :last_sign_in_at
      rename_column :users, :current_login_ip, :current_sign_in_ip
      rename_column :users, :last_login_ip, :last_sign_in_ip

      ## Confirmable
      #t.string   :confirmation_token
      #t.datetime :confirmed_at
      #t.datetime :confirmation_sent_at
      #t.string   :unconfirmed_email # Only if using reconfirmable
      rename_column :users, :perishable_token, :confirmation_token

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    remove_column :users, :password_salt
    remove_column :users, :last_request_at

    #add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
