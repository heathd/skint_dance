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

ActiveRecord::Schema.define(:version => 20140803175922) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "day_ticket_order_ticket_types", :force => true do |t|
    t.integer "day_ticket_order_id"
    t.integer "ticket_type_id"
  end

  create_table "day_ticket_orders", :force => true do |t|
    t.string   "reference"
    t.string   "state"
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.text     "what_can_you_help_with"
    t.boolean  "camping"
    t.text     "comments"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "day_ticket_orders", ["reference"], :name => "index_day_ticket_orders_on_reference", :unique => true

  create_table "gocardless_bills", :force => true do |t|
    t.string   "gocardless_id"
    t.datetime "created_at"
    t.string   "description"
    t.string   "amount"
    t.string   "name"
    t.string   "status"
    t.string   "merchant_id"
    t.string   "source_type"
    t.string   "source_id"
    t.string   "user_id"
    t.string   "user_email"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.integer  "reservation_id"
  end

  create_table "pre_reservations", :force => true do |t|
    t.string   "reference"
    t.string   "email"
    t.string   "name"
    t.string   "resource_category"
    t.datetime "expires_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "reservations", :force => true do |t|
    t.string   "reference"
    t.string   "state"
    t.string   "payment_method"
    t.string   "payment_reference"
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.text     "what_can_you_help_with"
    t.boolean  "participate_in_fare_pool"
    t.string   "dietary_requirements"
    t.text     "comments"
    t.datetime "requested_at",             :null => false
    t.datetime "updated_at",               :null => false
    t.boolean  "camping"
    t.integer  "ticket_type_id"
    t.datetime "payment_due"
    t.string   "travelling_from"
  end

  add_index "reservations", ["reference"], :name => "index_reservations_on_reference", :unique => true

  create_table "ticket_types", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "price_in_pence"
    t.string  "gocardless_url"
    t.string  "paypal_partial"
    t.string  "resource_category"
  end

  create_table "waiting_list_entries", :force => true do |t|
    t.integer  "reservation_id"
    t.string   "resource_category"
    t.datetime "added_at"
    t.integer  "pre_reservation_id"
  end

  add_index "waiting_list_entries", ["pre_reservation_id"], :name => "index_waiting_list_entries_on_pre_reservation_id"

end
