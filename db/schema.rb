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

ActiveRecord::Schema.define(version: 20170119063129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "pandore_id",   limit: 12,                                                       comment: "账户id,用户资金流转"
    t.decimal  "amount",                  precision: 20, scale: 2, default: "0.0",              comment: "余额"
    t.integer  "account_type",                                                                  comment: "账户类型"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.index ["pandore_id"], name: "index_accounts_on_pandore_id", unique: true, using: :btree
  end

  create_table "deals", force: :cascade do |t|
    t.decimal  "amount",                    precision: 20, scale: 2, default: "0.0",              comment: "当前交易金额"
    t.integer  "debit_user_id",                                                                   comment: "借款方"
    t.integer  "credit_user_id",                                                                  comment: "放款方"
    t.string   "deal_code",      limit: 12,                                                       comment: "交易码"
    t.integer  "status"
    t.datetime "loaned_at"
    t.datetime "refunded_at"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.index ["credit_user_id"], name: "index_deals_on_credit_user_id", using: :btree
    t.index ["deal_code"], name: "index_deals_on_deal_code", unique: true, using: :btree
    t.index ["debit_user_id"], name: "index_deals_on_debit_user_id", using: :btree
    t.index ["status"], name: "index_deals_on_status", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "auth_token", limit: 40
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "account_id"
    t.index ["account_id"], name: "index_users_on_account_id", using: :btree
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  end

  create_table "vouchers", force: :cascade do |t|
    t.string  "deal_code",       limit: 12,                                          comment: "交易码"
    t.decimal "amount",                     precision: 20, scale: 2, default: "0.0", comment: "当前交易金额"
    t.string  "voucher_code",    limit: 20,                                          comment: "流水码"
    t.integer "status"
    t.integer "trade_type",                                                          comment: "交易类型, 借款:loan, 还款:refund"
    t.integer "income_user_id",                                                      comment: "入账"
    t.integer "expense_user_id",                                                     comment: "出账"
    t.integer "deal_id"
    t.index ["deal_id"], name: "index_vouchers_on_deal_id", using: :btree
    t.index ["expense_user_id"], name: "index_vouchers_on_expense_user_id", using: :btree
    t.index ["income_user_id"], name: "index_vouchers_on_income_user_id", using: :btree
    t.index ["trade_type"], name: "index_vouchers_on_trade_type", using: :btree
  end

  add_foreign_key "users", "accounts"
  add_foreign_key "vouchers", "deals"
end
