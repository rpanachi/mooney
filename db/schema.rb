# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120820000000) do

  create_table "accounts", :force => true do |t|
    t.string   "name",       :limit => 50
    t.decimal  "balance",                  :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "categories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id",  :default => 0, :null => false
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["user_id"], :name => "index_categories_on_user_id"

  create_table "entries", :force => true do |t|
    t.integer  "account_id"
    t.date     "date"
    t.float    "value"
    t.string   "description", :limit => 100
    t.boolean  "paid",                       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "category_id"
  end

  add_index "entries", ["account_id"], :name => "index_entries_on_account_id"
  add_index "entries", ["category_id"], :name => "index_entries_on_category_id"
  add_index "entries", ["date"], :name => "index_entries_on_date"
  add_index "entries", ["paid"], :name => "index_entries_on_paid"
  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"
  add_index "entries", ["value"], :name => "index_entries_on_value"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "perishable_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
