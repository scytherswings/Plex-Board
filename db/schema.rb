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

ActiveRecord::Schema.define(version: 20151208025136) do

  create_table "plex_objects", force: :cascade do |t|
    t.string   "image"
    t.string   "thumb_url"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "plex_object_flavor_id"
    t.string   "plex_object_flavor_type"
    t.string   "media_title"
  end

  add_index "plex_objects", ["plex_object_flavor_id"], name: "index_plex_objects_on_plex_object_flavor_id"
  add_index "plex_objects", ["plex_object_flavor_type"], name: "index_plex_objects_on_plex_object_flavor_type"

  create_table "plex_recently_addeds", force: :cascade do |t|
    t.datetime "added_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "plex_service_id"
  end

  add_index "plex_recently_addeds", ["plex_service_id"], name: "index_plex_recently_addeds_on_plex_service_id"

  create_table "plex_services", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plex_sessions", force: :cascade do |t|
    t.integer  "progress"
    t.integer  "total_duration"
    t.string   "plex_user_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "session_key"
    t.integer  "plex_service_id"
  end

  add_index "plex_sessions", ["plex_service_id"], name: "index_plex_sessions_on_plex_service_id"
  add_index "plex_sessions", ["session_key"], name: "index_plex_sessions_on_session_key"

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "dns_name"
    t.string   "ip"
    t.string   "url"
    t.boolean  "online_status"
    t.integer  "port"
    t.datetime "last_seen"
    t.integer  "service_flavor_id"
    t.string   "service_flavor_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "services", ["service_flavor_id"], name: "index_services_on_service_flavor_id"
  add_index "services", ["service_flavor_type"], name: "index_services_on_service_flavor_type"

end
