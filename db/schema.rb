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

ActiveRecord::Schema.define(version: 20161210113221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "battles", ["user_id"], name: "index_battles_on_user_id", using: :btree

  create_table "counts", force: :cascade do |t|
    t.integer  "battle_id"
    t.integer  "hashtag_id"
    t.datetime "last_refresh"
    t.integer  "counter"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "counts", ["battle_id"], name: "index_counts_on_battle_id", using: :btree
  add_index "counts", ["hashtag_id"], name: "index_counts_on_hashtag_id", using: :btree

  create_table "daily_hashtag_counts", force: :cascade do |t|
    t.integer  "hashtag_id"
    t.integer  "count"
    t.datetime "last_refresh"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "daily_hashtag_counts", ["hashtag_id"], name: "index_daily_hashtag_counts_on_hashtag_id", using: :btree

  create_table "hashtags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "tweets", id: false, force: :cascade do |t|
    t.datetime "date"
    t.integer  "id",         null: false
    t.integer  "hashtag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tweets", ["hashtag_id"], name: "index_tweets_on_hashtag_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "mail"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "access_token"
  end

  add_foreign_key "battles", "users"
  add_foreign_key "counts", "battles"
  add_foreign_key "counts", "hashtags"
  add_foreign_key "daily_hashtag_counts", "hashtags"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "tweets", "hashtags"
end
