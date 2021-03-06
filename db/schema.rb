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

ActiveRecord::Schema.define(:version => 20120903140055) do

  create_table "customjxpaths", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "jxpathconditions", :force => true do |t|
    t.string  "value"
    t.string  "description"
    t.integer "subscription_id"
  end

  create_table "nuxeotokens", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
    t.string   "secret"
    t.integer  "user_id"
  end

  create_table "proxies", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "subscription_types", :force => true do |t|
    t.string   "description"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "user_id"
    t.integer  "webservicetolisten_id"
    t.integer  "subscription_type_id"
    t.integer  "proxy_id"
  end

  create_table "subscriptions_webservicetolaunches", :id => false, :force => true do |t|
    t.integer "subscription_id"
    t.integer "webservicetolaunch_id"
  end

  create_table "templatejxpaths", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "role_id"
  end

  create_table "webservicetolaunches", :force => true do |t|
    t.string   "description"
    t.string   "environment"
    t.string   "nuxeouid"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "webservicetolistens", :force => true do |t|
    t.string   "archipath"
    t.datetime "date"
    t.string   "description"
    t.string   "environment"
    t.string   "nuxeouid"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
