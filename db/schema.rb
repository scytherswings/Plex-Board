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

ActiveRecord::Schema.define(version: 20170428012623) do

  create_table "plex_objects", force: :cascade do |t|
    t.string "image"
    t.string "thumb_url", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plex_object_flavor_id"
    t.string "plex_object_flavor_type"
    t.string "media_title", null: false
    t.index ["plex_object_flavor_id"], name: "index_plex_objects_on_plex_object_flavor_id"
    t.index ["plex_object_flavor_type"], name: "index_plex_objects_on_plex_object_flavor_type"
  end

  create_table "plex_recently_addeds", force: :cascade do |t|
    t.datetime "added_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plex_service_id"
    t.string "uuid", null: false
    t.index ["plex_service_id"], name: "index_plex_recently_addeds_on_plex_service_id"
    t.index ["uuid"], name: "index_plex_recently_addeds_on_uuid"
  end

  create_table "plex_services", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plex_sessions", force: :cascade do |t|
    t.integer "progress", null: false
    t.integer "total_duration", null: false
    t.string "plex_user_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_key", null: false
    t.integer "plex_service_id"
    t.string "stream_type", null: false
    t.index ["plex_service_id"], name: "index_plex_sessions_on_plex_service_id"
    t.index ["session_key"], name: "index_plex_sessions_on_session_key"
  end

  create_table "server_loads", force: :cascade do |t|
    t.string "name"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.string "dns_name"
    t.string "ip"
    t.string "url", null: false
    t.integer "port", null: false
    t.integer "service_flavor_id"
    t.string "service_flavor_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_flavor_id"], name: "index_services_on_service_flavor_id"
    t.index ["service_flavor_type"], name: "index_services_on_service_flavor_type"
  end

  create_table "weathers", force: :cascade do |t|
    t.string "api_key"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.text "units"
    t.string "city"
    t.string "state"
  end

end
