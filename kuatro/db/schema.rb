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

ActiveRecord::Schema.define(:version => 20120418013613) do

  create_table "albums", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.boolean  "hidden"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "description"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title",                                  :null => false
    t.text     "contents"
    t.string   "page_code"
    t.integer  "authorable_id"
    t.string   "authorable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",          :default => "publish"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", :force => true do |t|
    t.string   "code"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featured_images", :force => true do |t|
    t.string   "description"
    t.string   "fimage_file_name"
    t.string   "fimage_content_type"
    t.integer  "fimage_file_size"
    t.datetime "fimage_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", :force => true do |t|
    t.string   "title"
    t.text     "contents"
    t.string   "limage_description"
    t.string   "limage_file_name"
    t.string   "limage_content_type"
    t.integer  "limage_file_size"
    t.datetime "limage_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author",              :null => false
    t.string   "alignment",           :null => false
  end

  create_table "pictures", :force => true do |t|
    t.integer  "album_id"
    t.boolean  "hidden",             :default => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",                           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "role"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
