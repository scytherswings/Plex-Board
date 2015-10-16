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

ActiveRecord::Schema.define(version: 20151015035631) do

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "dns_name"
    t.string   "ip"
    t.string   "url"
    t.string   "username"
    t.string   "api"
    t.string   "service_type"
    t.string   "password"
    t.string   "token"
    t.boolean  "online_status"
    t.integer  "port"
    t.datetime "last_seen"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "services", ["name"], name: "index_services_on_name", unique: true
  add_index "services", ["url"], name: "index_services_on_url", unique: true

  create_table "sessions", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "user_name"
    t.string   "image"
    t.string   "media_title"
    t.string   "thumb_url"
    t.string   "connection_string"
    t.integer  "total_duration"
    t.integer  "progress"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "session_key"
  end

  add_index "sessions", ["service_id"], name: "index_sessions_on_service_id"
  add_index "sessions", ["session_key", "service_id"], name: "index_sessions_on_session_key_and_service_id", unique: true

end
