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

ActiveRecord::Schema.define(:version => 20120403100503) do

  create_table "address_extensions", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "number"
    t.string   "building_name"
    t.string   "floor_number"
    t.string   "lot_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.integer "addressable_id"
    t.string  "addressable_type"
    t.integer "country_id"
    t.integer "state_id"
    t.string  "city_name"
    t.string  "section_name"
    t.string  "postcode"
    t.string  "street"
    t.string  "address_number"
    t.string  "building_name"
    t.string  "address_roadname"
    t.string  "floor_number"
    t.string  "address_lot_number"
    t.string  "lat"
    t.string  "lng"
    t.integer "map_address_id"
    t.string  "state_name"
    t.string  "country_name"
  end

  add_index "addresses", ["state_id"], :name => "index_addresses_on_state_id"

  create_table "advertisements", :force => true do |t|
    t.integer  "advertiser_id"
    t.string   "advertiser_type"
    t.integer  "views"
    t.string   "landing_url"
    t.integer  "creator_id"
    t.string   "creator_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", :force => true do |t|
    t.string   "alert_type"
    t.string   "title"
    t.text     "description"
    t.integer  "sender_id"
    t.string   "sender_type"
    t.string   "status",          :default => "pending", :null => false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reportable_id"
    t.string   "reportable_type"
  end

  create_table "announcements", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "contents"
    t.string   "url_link"
    t.integer  "announceable_id"
    t.string   "announceable_type"
    t.string   "announce_type",       :default => "user", :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "announcements", ["user_id"], :name => "index_announcements_on_user_id"

  create_table "assets", :force => true do |t|
    t.integer  "authorable_id"
    t.string   "authorable_type"
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["authorable_id", "authorable_type"], :name => "index_assets_on_authorable_id_and_authorable_type"
  add_index "assets", ["uploadable_id", "uploadable_type"], :name => "index_assets_on_uploadable_id_and_uploadable_type"

  create_table "brands", :force => true do |t|
    t.integer "category_id"
    t.string  "name"
    t.text    "description"
    t.integer "asset_id"
    t.integer "views",       :default => 0
    t.integer "place_id"
    t.string  "tags"
    t.text    "extra_info"
  end

  add_index "brands", ["place_id"], :name => "index_brands_on_place_id"

  create_table "categories", :force => true do |t|
    t.string  "code",      :null => false
    t.string  "name"
    t.integer "parent_id"
  end

  add_index "categories", ["code"], :name => "index_categories_on_code"
  add_index "categories", ["id", "parent_id"], :name => "index_categories_on_id_and_parent_id"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "category_features", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "cities", :force => true do |t|
    t.integer "state_id"
    t.string  "name"
    t.string  "code"
    t.string  "timezone"
    t.string  "lat"
    t.string  "lng"
  end

  add_index "cities", ["code"], :name => "index_cities_on_code"

  create_table "companies", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "confirmations", :force => true do |t|
    t.string  "confirmable_type"
    t.integer "confirmable_id"
    t.string  "token"
    t.string  "username"
    t.boolean "used"
    t.date    "expire_at"
  end

  add_index "confirmations", ["token"], :name => "index_confirmations_on_token"

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  add_index "countries", ["code"], :name => "index_countries_on_code"

  create_table "deals", :force => true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.string   "name"
    t.text     "description"
    t.integer  "asset_id"
    t.integer  "views",             :default => 0
    t.string   "tags"
    t.text     "extra_info"
    t.string   "page_code"
    t.date     "start"
    t.date     "end"
    t.boolean  "ongoing",           :default => false
    t.string   "locations"
    t.string   "telno"
    t.string   "faxno"
    t.string   "mobileno"
    t.string   "email"
    t.string   "website"
    t.integer  "organizer_id"
    t.integer  "user_id"
    t.string   "status"
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_place_address", :default => true
    t.string   "sort_status",       :default => "0"
    t.boolean  "use_place_info",    :default => true
  end

  add_index "deals", ["category_id"], :name => "index_deals_on_category_id"
  add_index "deals", ["id", "page_code"], :name => "index_deals_on_id_and_page_code"
  add_index "deals", ["place_id", "status"], :name => "index_deals_on_place_id_and_status"
  add_index "deals", ["place_id"], :name => "index_deals_on_place_id"

  create_table "discounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "discount_condition"
    t.string   "discount_for"
    t.string   "discount_for2"
    t.string   "discount_criteria"
    t.decimal  "amount",             :precision => 8, :scale => 2
    t.integer  "duration"
    t.string   "discount_code"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status",                                           :default => "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_dates", :force => true do |t|
    t.integer  "event_id"
    t.date     "date"
    t.string   "start_time"
    t.string   "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.string   "name"
    t.text     "description"
    t.text     "pricing_information"
    t.integer  "asset_id"
    t.integer  "views",                                             :default => 0
    t.string   "tags"
    t.text     "extra_info"
    t.string   "page_code"
    t.date     "schedule"
    t.string   "telno"
    t.string   "faxno"
    t.string   "mobileno"
    t.string   "email"
    t.string   "website"
    t.integer  "organizer_id"
    t.integer  "user_id"
    t.string   "status"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "event_type"
    t.decimal  "from_price",          :precision => 8, :scale => 2
    t.decimal  "to_price",            :precision => 8, :scale => 2
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_place_address",                                 :default => true
    t.string   "pricing_type",                                      :default => "free"
    t.string   "event_day"
    t.integer  "sort_status",                                       :default => 0
    t.boolean  "use_place_info",                                    :default => true
  end

  add_index "events", ["category_id"], :name => "index_events_on_category_id"
  add_index "events", ["id", "page_code"], :name => "index_events_on_id_and_page_code"
  add_index "events", ["place_id"], :name => "index_events_on_place_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["user_id", "created_at"], :name => "index_favorites_on_user_id_and_created_at"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "global_settings", :force => true do |t|
    t.string "option_name",  :null => false
    t.string "code",         :null => false
    t.string "option_value", :null => false
  end

  create_table "highlight_categories", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "group_name"
    t.string "image"
  end

  create_table "highlights", :force => true do |t|
    t.integer  "highlightable_id"
    t.string   "highlightable_type"
    t.integer  "highlight_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "listing_id"
    t.integer  "listing_type"
    t.date     "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["user_id", "created_at"], :name => "index_histories_on_user_id_and_created_at"
  add_index "histories", ["user_id", "listing_id", "created_at"], :name => "index_histories_on_user_id_and_listing_id_and_created_at"

  create_table "listing_types", :force => true do |t|
    t.string "code"
    t.string "name"
  end

  add_index "listing_types", ["code"], :name => "index_listing_types_on_code"

  create_table "listing_updates", :force => true do |t|
    t.integer  "updateable_id"
    t.string   "updateable_type"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "place_id"
    t.string   "section"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action_name"
    t.boolean  "shown",           :default => true
  end

  create_table "listings", :force => true do |t|
    t.integer  "listable_id"
    t.string   "listable_type"
    t.string   "listing_type"
    t.integer  "category_id"
    t.integer  "status",              :default => 0
    t.string   "name"
    t.text     "description"
    t.string   "tags"
    t.string   "website_url"
    t.text     "extra_info"
    t.integer  "ranking"
    t.integer  "total_rates",         :default => 0
    t.integer  "views",               :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.text     "gallery_title"
    t.text     "gallery_description"
    t.text     "shouts"
    t.string   "category_name"
    t.string   "sub_category_name"
    t.text     "address_index"
    t.text     "features_index"
    t.string   "monfrom"
    t.string   "monto"
    t.string   "tuefrom"
    t.string   "tueto"
    t.string   "wedfrom"
    t.string   "wedto"
    t.string   "thufrom"
    t.string   "thuto"
    t.string   "frifrom"
    t.string   "frito"
    t.string   "satfrom"
    t.string   "satto"
    t.string   "sunfrom"
    t.string   "sunto"
    t.string   "monfrompm"
    t.string   "montopm"
    t.string   "tuefrompm"
    t.string   "tuetopm"
    t.string   "wedfrompm"
    t.string   "wedtopm"
    t.string   "thufrompm"
    t.string   "thutopm"
    t.string   "frifrompm"
    t.string   "fritopm"
    t.string   "satfrompm"
    t.string   "sattopm"
    t.string   "sunfrompm"
    t.string   "suntopm"
  end

  add_index "listings", ["status"], :name => "index_listings_on_status"

  create_table "logins", :force => true do |t|
    t.string "username"
    t.string "ipaddress"
    t.date   "created_at"
  end

  add_index "logins", ["username"], :name => "index_logins_on_username"

  create_table "logs", :force => true do |t|
    t.string   "location"
    t.text     "content"
    t.integer  "user_id"
    t.string   "url"
    t.text     "params"
    t.text     "user_agent"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_addresses", :force => true do |t|
    t.integer  "country_id"
    t.integer  "state_id"
    t.integer  "city_id"
    t.integer  "section_id"
    t.string   "street"
    t.string   "number"
    t.string   "building_name"
    t.string   "floor_number"
    t.string   "lot_number"
    t.string   "complete_address"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marked_viewed", :force => true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "listing_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marked_viewed", ["user_id", "viewable_id", "viewable_type"], :name => "index_marked_viewed_on_user_id_and_viewable_id_and_viewable_type"

  create_table "message_threads", :force => true do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_threads", ["receiver_id"], :name => "index_message_threads_on_receiver_id"
  add_index "message_threads", ["sender_id"], :name => "index_message_threads_on_sender_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.text     "contents"
    t.string   "subject"
    t.integer  "viewer_id"
    t.string   "viewer_type"
    t.integer  "message_thread_id"
    t.string   "msgtype",           :default => "inbox"
    t.boolean  "is_viewed",         :default => false
    t.integer  "email_template_id"
    t.string   "contact_email"
    t.string   "contact_name"
    t.string   "contact_telno"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["receiver_id", "message_thread_id"], :name => "index_messages_on_receiver_id_and_message_thread_id"
  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"
  add_index "messages", ["sender_id", "message_thread_id"], :name => "index_messages_on_sender_id_and_message_thread_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "notification_type"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "show_type",         :default => "both"
  end

  create_table "organizers", :force => true do |t|
    t.integer  "place_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.string   "package_name"
    t.decimal  "price",                 :precision => 8, :scale => 2
    t.string   "payment_frequency"
    t.integer  "contract_length",                                     :default => 12
    t.integer  "allowed_announcements",                               :default => 0
    t.integer  "allowed_images",                                      :default => 0
    t.integer  "allowed_events",                                      :default => 0
    t.integer  "allowed_deals",                                       :default => 0
    t.boolean  "full_data_service",                                   :default => false
    t.string   "package_code",                                        :default => "basic_monthly"
    t.integer  "ranking"
    t.integer  "about_char_limit",                                    :default => 250
    t.boolean  "about_no_limit",                                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price_per_day",         :precision => 8, :scale => 2
    t.decimal  "price_per_month",       :precision => 8, :scale => 2
    t.decimal  "price_per_year",        :precision => 8, :scale => 2
    t.decimal  "sales_tax",             :precision => 8, :scale => 2
    t.boolean  "logo_on_map",                                         :default => false
    t.integer  "aboutus_characters",                                  :default => -1
    t.integer  "allowed_shouts",                                      :default => 0
    t.boolean  "customer_service",                                    :default => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.string   "package_id"
    t.string   "payment_method"
    t.string   "invoice_no"
    t.decimal  "amount",         :precision => 8, :scale => 2
    t.string   "status"
    t.date     "contract_start"
    t.date     "contract_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "pictures", :force => true do |t|
    t.integer  "pictureable_id"
    t.string   "pictureable_type"
    t.string   "name"
    t.string   "description"
    t.string   "picture_type"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "name"
    t.text     "description"
    t.string   "telephone_numbers"
    t.string   "fax_numbers"
    t.string   "mobile_numbers"
    t.string   "website_url"
    t.string   "email"
    t.string   "tags"
    t.boolean  "status",            :default => false
    t.string   "page_code"
    t.integer  "package",           :default => 0
    t.integer  "views",             :default => 0
    t.text     "extra_info"
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "operation_hours"
    t.text     "operation_times"
    t.text     "category_features"
    t.string   "sub_category"
    t.string   "buzzword"
  end

  add_index "places", ["category_id", "tags"], :name => "index_places_on_category_id_and_tags"
  add_index "places", ["id", "page_code"], :name => "index_places_on_id_and_page_code"
  add_index "places", ["name"], :name => "index_places_on_name"
  add_index "places", ["page_code"], :name => "index_places_on_page_code"
  add_index "places", ["status", "created_at"], :name => "index_places_on_status_and_created_at"
  add_index "places", ["status"], :name => "index_places_on_status"
  add_index "places", ["user_id"], :name => "index_places_on_user_id"

  create_table "prices", :force => true do |t|
    t.integer  "priceable_id"
    t.string   "priceable_type"
    t.string   "label"
    t.decimal  "price",          :precision => 8, :scale => 2
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.string   "name"
    t.text     "description"
    t.integer  "asset_id"
    t.integer  "views",       :default => 0
    t.string   "tags"
    t.text     "extra_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["place_id"], :name => "index_products_on_place_id"

  create_table "rates", :force => true do |t|
    t.string   "name"
    t.decimal  "per_day",                   :precision => 8, :scale => 2
    t.decimal  "per_month",                 :precision => 8, :scale => 2
    t.decimal  "per_year",                  :precision => 8, :scale => 2
    t.decimal  "monthly_subscription_rate", :precision => 8, :scale => 2
    t.decimal  "govt_tax",                  :precision => 8, :scale => 2
    t.decimal  "freebies_value",            :precision => 8, :scale => 2
    t.integer  "deals_credits"
    t.integer  "deal_discounts"
    t.boolean  "customer_service",                                        :default => false
    t.boolean  "logo_display_onmap",                                      :default => false
    t.string   "exposure"
    t.integer  "image_limit",                                             :default => 1
    t.integer  "products_limit",                                          :default => 0
    t.integer  "services_limit",                                          :default => 0
    t.integer  "brands_limit",                                            :default => 0
    t.integer  "jobs_limit",                                              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["rateable_id", "rateable_type", "user_id"], :name => "index_ratings_on_rateable_id_and_rateable_type_and_user_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "raw_cities", :primary_key => "CityId", :force => true do |t|
    t.integer "CountryID", :limit => 2,  :null => false
    t.integer "RegionID",  :limit => 2,  :null => false
    t.string  "City",      :limit => 45, :null => false
    t.float   "Latitude",                :null => false
    t.float   "Longitude",               :null => false
    t.string  "TimeZone",  :limit => 10, :null => false
    t.integer "DmaId",     :limit => 2
    t.string  "County",    :limit => 25
    t.string  "Code",      :limit => 4
  end

  create_table "raw_countries", :primary_key => "CountryId", :force => true do |t|
    t.string  "Country",             :limit => 50, :null => false
    t.string  "FIPS104",             :limit => 2,  :null => false
    t.string  "ISO2",                :limit => 2,  :null => false
    t.string  "ISO3",                :limit => 3,  :null => false
    t.string  "ISON",                :limit => 4,  :null => false
    t.string  "Internet",            :limit => 2,  :null => false
    t.string  "Capital",             :limit => 25
    t.string  "MapReference",        :limit => 50
    t.string  "NationalitySingular", :limit => 35
    t.string  "NationalityPlural",   :limit => 35
    t.string  "Currency",            :limit => 30
    t.string  "CurrencyCode",        :limit => 3
    t.integer "Population",          :limit => 8
    t.string  "Title",               :limit => 50
    t.string  "Comment"
  end

  create_table "readables", :force => true do |t|
    t.integer  "reader_id"
    t.string   "reader_type"
    t.integer  "readable_id"
    t.string   "readable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
  end

  add_index "readables", ["readable_id", "readable_type"], :name => "index_readables_on_readable_id_and_readable_type"
  add_index "readables", ["reader_id", "reader_type"], :name => "index_readables_on_reader_id_and_reader_type"

  create_table "regions", :primary_key => "RegionID", :force => true do |t|
    t.integer "CountryID", :limit => 2,  :null => false
    t.string  "Region",    :limit => 45, :null => false
    t.string  "Code",      :limit => 8,  :null => false
    t.string  "ADM1Code",  :limit => 4,  :null => false
  end

  create_table "reported_listings", :force => true do |t|
    t.integer  "listing_id"
    t.string   "report_type"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searchables", :force => true do |t|
    t.string   "text"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.string   "column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.integer "city_id"
    t.string  "name"
    t.integer "postalcode"
  end

  add_index "sections", ["name"], :name => "index_sections_on_name"

  create_table "services", :force => true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.string   "name"
    t.text     "description"
    t.integer  "asset_id"
    t.integer  "views",       :default => 0
    t.string   "tags"
    t.text     "extra_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["place_id"], :name => "index_services_on_place_id"

  create_table "shouts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shoutable_id"
    t.string   "shoutable_type"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "socials", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.integer  "uid"
    t.text     "info"
    t.text     "credentials"
    t.text     "extra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.integer "country_id"
  end

  add_index "states", ["code"], :name => "index_states_on_code"
  add_index "states", ["id"], :name => "index_states_on_id"

  create_table "subscribers", :force => true do |t|
    t.string   "company_name"
    t.string   "email"
    t.string   "business_type"
    t.string   "contact_person"
    t.string   "contact_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suspended_accounts", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "reason_code", :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "section_type"
    t.string   "title"
    t.string   "description"
    t.string   "photo_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_types", :force => true do |t|
    t.string "code"
    t.string "name"
  end

  add_index "user_types", ["code"], :name => "index_user_types_on_code"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "middlename"
    t.string   "user_type",                      :default => "regular"
    t.integer  "status",                         :default => 0
    t.string   "gender"
    t.date     "dob"
    t.string   "secondary_email"
    t.string   "race"
    t.string   "religion"
    t.string   "nationality"
    t.string   "company_name"
    t.string   "work_from"
    t.string   "work_to"
    t.string   "designation"
    t.string   "description"
    t.string   "college"
    t.string   "profession"
    t.string   "year_from"
    t.string   "year_to"
    t.string   "grade"
    t.integer  "city_id"
    t.integer  "section_id"
    t.string   "telno"
    t.string   "mobileno"
    t.string   "direct_line_no"
    t.string   "faxno"
    t.string   "website_url"
    t.string   "facebook"
    t.string   "twitter"
    t.integer  "address_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "advert_company_name"
    t.string   "advert_company_name_registered"
    t.string   "advert_company_reg_number"
    t.string   "settings"
    t.string   "package_typ"
    t.string   "steps",                          :default => "welcome"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_facebook"
    t.text     "facebook_information"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "find_out"
    t.datetime "activated_at"
    t.string   "city_name"
    t.string   "state_name"
    t.string   "country_name"
    t.boolean  "viewed_profile",                 :default => false
  end

  add_index "users", ["status", "id"], :name => "index_users_on_status_and_id"
  add_index "users", ["username", "password", "status"], :name => "index_users_on_username_and_password_and_status"
  add_index "users", ["username", "password"], :name => "index_users_on_username_and_password"
  add_index "users", ["username"], :name => "index_users_on_username"

end
