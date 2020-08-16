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

ActiveRecord::Schema.define(version: 20200704103955) do

  create_table "billing_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "billing_id"
    t.integer  "item_id"
    t.decimal  "item_rate",     precision: 12, scale: 3, default: "0.0"
    t.decimal  "item_quantity", precision: 12, scale: 3, default: "0.0"
    t.decimal  "item_total",    precision: 12, scale: 3, default: "0.0"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.index ["billing_id"], name: "index_billing_details_on_billing_id", using: :btree
    t.index ["item_id"], name: "index_billing_details_on_item_id", using: :btree
  end

  create_table "billings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "customer_id"
    t.datetime "billing_date"
    t.string   "billing_number", limit: 20,                                          null: false
    t.decimal  "total_amount",              precision: 12, scale: 3, default: "0.0"
    t.decimal  "paid_amount",               precision: 12, scale: 3, default: "0.0"
    t.decimal  "pending_amount",            precision: 12, scale: 3, default: "0.0"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.index ["customer_id"], name: "index_billings_on_customer_id", using: :btree
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "contact_number1"
    t.string   "contact_number2"
    t.string   "contact_number3"
    t.string   "address1"
    t.string   "address2"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code",                limit: 10,                                          null: false
    t.string   "name",                limit: 50,                                          null: false
    t.decimal  "qty_in_stock",                   precision: 12, scale: 3, default: "0.0"
    t.decimal  "last_receiving_rate",            precision: 12, scale: 3, default: "0.0"
    t.decimal  "conversion_rate",                precision: 12, scale: 3, default: "1.0"
    t.decimal  "adjustmented_qty",               precision: 12, scale: 3, default: "0.0"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.integer  "receiving_uom_id"
    t.integer  "billing_uom_id"
    t.index ["billing_uom_id"], name: "index_items_on_billing_uom_id", using: :btree
    t.index ["receiving_uom_id"], name: "index_items_on_receiving_uom_id", using: :btree
  end

  create_table "receiving_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "receiving_id"
    t.integer  "item_id"
    t.decimal  "item_rate",     precision: 12, scale: 3, default: "0.0"
    t.decimal  "item_quantity", precision: 12, scale: 3, default: "0.0"
    t.decimal  "item_total",    precision: 12, scale: 3, default: "0.0"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.index ["item_id"], name: "index_receiving_details_on_item_id", using: :btree
    t.index ["receiving_id"], name: "index_receiving_details_on_receiving_id", using: :btree
  end

  create_table "receivings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "vendor_id"
    t.datetime "receiving_date"
    t.string   "receiving_number", limit: 20,                                          null: false
    t.string   "bill_number",      limit: 20
    t.datetime "bill_date"
    t.decimal  "total_amount",                precision: 12, scale: 3, default: "0.0"
    t.decimal  "paid_amount",                 precision: 12, scale: 3, default: "0.0"
    t.decimal  "pending_amount",              precision: 12, scale: 3, default: "0.0"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.index ["vendor_id"], name: "index_receivings_on_vendor_id", using: :btree
  end

  create_table "uoms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code",       limit: 10, null: false
    t.string   "name",       limit: 50, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "full_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "vendors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "contact_number1"
    t.string   "contact_number2"
    t.string   "contact_number3"
    t.string   "address1"
    t.string   "address2"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "billing_details", "billings"
  add_foreign_key "billing_details", "items"
  add_foreign_key "billings", "customers"
  add_foreign_key "receiving_details", "items"
  add_foreign_key "receiving_details", "receivings"
  add_foreign_key "receivings", "vendors"
end
