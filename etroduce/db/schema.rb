# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110803140008) do

  create_table "assets", :force => true do |t|
    t.integer  "created_by"
    t.integer  "opportunity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "carts", :force => true do |t|
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  add_index "categories", ["code"], :name => "index_categories_on_code"

  create_table "contact_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "privacy",     :default => 0
  end

  add_index "contact_lists", ["user_id"], :name => "index_contact_lists_on_user_id"

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_user_id"
    t.date     "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "inbound_sms", :force => true do |t|
    t.integer  "destination_address"
    t.string   "message"
    t.string   "message_id"
    t.integer  "sender_address"
    t.datetime "date_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.text     "message"
    t.date     "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "expertise"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "unit_price",     :limit => 10, :precision => 10, :scale => 0
    t.integer  "opportunity_id"
    t.integer  "cart_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_threads", :force => true do |t|
    t.string   "subject"
    t.integer  "to_id"
    t.integer  "from_id"
    t.integer  "opportunity_id"
    t.boolean  "has_read",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "referred_email"
  end

  add_index "message_threads", ["from_id"], :name => "index_message_threads_on_from_id"
  add_index "message_threads", ["to_id"], :name => "index_message_threads_on_to_id"

  create_table "messages", :force => true do |t|
    t.integer  "to_id",             :null => false
    t.integer  "from_id",           :null => false
    t.string   "body",              :null => false
    t.text     "message_thread_id", :null => false
    t.integer  "viewable_to",       :null => false
    t.string   "msgtype",           :null => false
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["from_id"], :name => "index_messages_on_from_id"
  add_index "messages", ["msgtype", "from_id"], :name => "index_messages_on_msgtype_and_from_id"
  add_index "messages", ["msgtype", "to_id"], :name => "index_messages_on_msgtype_and_to_id"
  add_index "messages", ["to_id"], :name => "index_messages_on_to_id"

  create_table "opportunities", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "description"
    t.date     "expire_at"
    t.datetime "closed_at"
    t.string   "location"
    t.string   "country"
    t.integer  "privacy",                                            :default => 0,          :null => false
    t.date     "created_at"
    t.date     "updated_at"
    t.string   "zipcode"
    t.integer  "category_id"
    t.integer  "status",                                             :default => 0
    t.integer  "parent_post_id"
    t.text     "remarks"
    t.decimal  "price",               :precision => 10, :scale => 2
    t.string   "notify_contact_list"
    t.string   "subdomain"
<<<<<<< HEAD
    t.string   "post_type",                                          :default => "personal"
    t.integer  "views"
=======
>>>>>>> cbd624191e54ba80d230f67f3534ed32e75566b7
  end

  add_index "opportunities", ["expire_at"], :name => "index_opportunities_on_expire_at"
  add_index "opportunities", ["user_id"], :name => "index_opportunities_on_user_id"

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "cart_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "express_token"
    t.string   "express_payer_id"
  end

  create_table "password_requests", :force => true do |t|
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "cart_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "cart_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string "code"
    t.string "name"
  end

  create_table "subdomains", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "price_monthly",  :limit => 10, :precision => 10, :scale => 0
    t.integer  "price_per_post", :limit => 10, :precision => 10, :scale => 0
    t.date     "expire_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "registration_token"
    t.datetime "deactivated_at"
    t.datetime "setup_at"
    t.datetime "verified_identity_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zipcode"
    t.string   "expertise"
    t.string   "username"
    t.string   "mobileno"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_facebook"
    t.string   "gender"
    t.integer  "timezone"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "mobile_number"
    t.string   "country_code"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "users_contact_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_list_id"
    t.integer  "contact_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_contact_lists", ["user_id", "contact_list_id"], :name => "index_users_contact_lists_on_user_id_and_contact_list_id"
  add_index "users_contact_lists", ["user_id"], :name => "index_users_contact_lists_on_user_id"

  create_table "zipcodes", :force => true do |t|
    t.string "code"
    t.string "city"
  end

  add_index "zipcodes", ["code"], :name => "index_zipcodes_on_code"

end
