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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150916022816) do

  create_table "couchpotatos", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "api"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deluges", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pings", force: :cascade do |t|
    t.datetime "lastuptime"
    t.boolean  "online_status"
    t.integer  "failed_pings"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "plexes", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sabnzbds", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "api"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "ip"
    t.string   "dns_name"
    t.integer  "port"
    t.string   "url"
    t.string   "type"
    t.string   "username"
    t.string   "password"
    t.string   "api"
  end

  add_index "services", ["name"], name: "index_services_on_name", unique: true
  add_index "services", ["url"], name: "index_services_on_url", unique: true

  create_table "sickrages", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "api"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
