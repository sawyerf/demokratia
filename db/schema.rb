# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_28_012006) do

  create_table "application_settings", force: :cascade do |t|
    t.integer "vote_timeline", default: 7
    t.integer "vote_min_valid", default: 50
  end

  create_table "choices", force: :cascade do |t|
    t.integer "vote_id"
    t.string "text"
    t.integer "vote_count"
    t.integer "index"
    t.integer "site_id"
    t.datetime "updated"
  end

  create_table "sites", force: :cascade do |t|
    t.string "domain"
    t.string "mykey"
    t.string "itskey"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "passwd"
    t.string "voter_hash"
  end

  create_table "vote_logs", force: :cascade do |t|
    t.integer "vote_id"
    t.integer "vote"
    t.integer "site_id"
    t.string "voter_hash"
    t.datetime "updated"
  end

  create_table "votes", force: :cascade do |t|
    t.string "quest"
    t.text "description"
    t.datetime "published"
    t.integer "status", default: 0
    t.string "winner"
    t.integer "voter_count", default: 0
    t.integer "choice_count", default: 0
    t.integer "site_id", default: 1
    t.integer "real_id"
    t.datetime "updated"
  end

end
