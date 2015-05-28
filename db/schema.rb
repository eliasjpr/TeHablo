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

ActiveRecord::Schema.define(version: 20130620140149) do

  create_table "bills", force: true do |t|
    t.integer "agent_id"
    t.integer "user_id"
    t.integer "service_id"
    t.string "account_number"
    t.string "phone"
    t.decimal "amount", precision: 10, scale: 0
    t.decimal "convenience_fee", precision: 10, scale: 0
    t.string "status"
    t.string "bill_preview_file_name"
    t.string "bill_preview_content_type"
    t.integer "bill_preview_file_size"
    t.datetime "bill_preview_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calling_ids", force: true do |t|
    t.string "call_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calls", force: true do |t|
    t.integer "call_duration", default: 0
    t.decimal "total_amount", precision: 12, scale: 8, default: 0.0
    t.string "parent_call_uuid"
    t.string "call_uuid"
    t.string "call_direction"
    t.string "to_number"
    t.decimal "total_rate", precision: 12, scale: 8, default: 0.0
    t.string "from_number"
    t.datetime "end_time"
    t.string "resource_uri"
    t.string "call_status"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "bill_duration", default: 0
    t.decimal "billed_duration", precision: 12, scale: 8, default: 0.0
    t.string "api_id"
    t.integer "agent_id"
  end

  create_table "countries", id: false, force: true do |t|
    t.string "Country Name"
    t.string "Code2"
    t.string "Code3"
  end

  create_table "rates", force: true do |t|
    t.string "direction"
    t.string "country"
    t.string "country_code"
    t.string "country_iso"
    t.integer "prefix"
    t.decimal "voice_rate", precision: 12, scale: 8, default: 0.0
    t.string "unit_in_seconds"
    t.string "number_type"
    t.decimal "rent_per_number", precision: 12, scale: 8, default: 0.0
    t.decimal "setup_cost_per_number", precision: 12, scale: 8, default: 0.0
    t.string "country_iso_2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipts", force: true do |t|
    t.integer "user_id"
    t.integer "agent_id"
    t.decimal "amount", precision: 12, scale: 8, default: 0.0
    t.decimal "commission_earned", precision: 12, scale: 8, default: 0.0
    t.decimal "commission_rate", precision: 12, scale: 8, default: 0.0
    t.string "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "transfer_status"
    t.string "transfer_fee"
    t.string "transfer_id"
  end

  create_table "recharges", force: true do |t|
    t.integer "user_id"
    t.integer "agent_id"
    t.integer "last4"
    t.string "card_type"
    t.boolean "paid", default: false
    t.decimal "amount", precision: 12, scale: 8, default: 0.0
    t.string "currency"
    t.boolean "refunded", default: false
    t.decimal "fee", precision: 12, scale: 8, default: 0.0
    t.boolean "captured", default: false
    t.string "failure_message"
    t.string "failure_code"
    t.decimal "amount_refunded", precision: 12, scale: 8, default: 0.0
    t.string "customer"
    t.string "invoice"
    t.string "description"
    t.string "dispute"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "logo"
    t.string "business_name"
    t.decimal "balance", precision: 12, scale: 8, default: 0.0
    t.decimal "commission", precision: 12, scale: 8, default: 0.0
    t.boolean "account_status"
    t.string "sid"
    t.string "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "password_digest"
    t.string "roles"
    t.string "commission_type"
    t.integer "parent_id"
    t.string "endpoint_id"
    t.string "stripe_customer_id"
    t.string "bank_account"
    t.string "routing_number"
    t.string "account_number"
    t.string "tax_id"
    t.string "stripe_recipient_id"
    t.string "endpoint_password"
  end

end
