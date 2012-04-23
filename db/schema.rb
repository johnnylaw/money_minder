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

ActiveRecord::Schema.define(:version => 20120423024800) do

  create_table "accounts", :force => true do |t|
    t.string   "name",                                  :null => false
    t.boolean  "is_spending",        :default => false
    t.boolean  "is_holding",         :default => false
    t.integer  "holding_account_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "expected_purchases", :force => true do |t|
    t.integer  "transaction_recipe_id"
    t.date     "scheduled_on"
    t.integer  "scheduled_for_hour"
    t.boolean  "is_complete",           :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "expected_purchases", ["scheduled_on"], :name => "index_expected_purchases_on_scheduled_on"

  create_table "expected_revenues", :force => true do |t|
    t.integer  "transaction_recipe_id"
    t.date     "scheduled_on"
    t.integer  "scheduled_for_hour"
    t.boolean  "is_complete",           :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "expected_revenues", ["scheduled_on"], :name => "index_expected_revenues_on_scheduled_on"

  create_table "expected_transaction_template", :force => true do |t|
    t.integer  "transaction_recipe_id",                    :null => false
    t.date     "scheduled_on"
    t.integer  "scheduled_for_hour"
    t.boolean  "is_complete",           :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "purchase_recipe_virtual_portions", :force => true do |t|
    t.integer  "purchase_recipe_id", :null => false
    t.integer  "virtual_account_id", :null => false
    t.integer  "cents",              :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "purchase_recipes", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.integer  "spill_over_virtual_account_id"
    t.integer  "vendor_id"
    t.integer  "default_inside_account_id",                                        :null => false
    t.string   "occurs_at"
    t.string   "base_interval"
    t.integer  "num_of_intervals",              :default => 1
    t.date     "starts_on"
    t.date     "ends_on"
    t.boolean  "is_promised"
    t.integer  "current_as_of_hours_prior"
    t.datetime "max_scheduled_out_to",          :default => '1970-01-01 00:00:00', :null => false
    t.integer  "cents",                                                            :null => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "purchases", :force => true do |t|
    t.integer  "vendor_id",       :null => false
    t.integer  "account_from_id", :null => false
    t.string   "memo"
    t.datetime "executed_at",     :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "purchases", ["executed_at"], :name => "index_purchases_on_executed_at"

  create_table "recipe_virtual_portion_template", :force => true do |t|
    t.integer  "purchase_recipe_id"
    t.integer  "revenue_recipe_id"
    t.integer  "virtual_account_id", :null => false
    t.integer  "cents",              :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "revenue_recipe_virtual_portions", :force => true do |t|
    t.integer  "revenue_recipe_id",  :null => false
    t.integer  "virtual_account_id", :null => false
    t.integer  "cents",              :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "revenue_recipes", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.integer  "spill_over_virtual_account_id"
    t.integer  "default_inside_account_id",                                        :null => false
    t.integer  "customer_id",                                                      :null => false
    t.string   "occurs_at"
    t.string   "base_interval"
    t.integer  "num_of_intervals",              :default => 1
    t.date     "starts_on"
    t.date     "ends_on"
    t.boolean  "is_promised"
    t.integer  "current_as_of_hours_prior"
    t.datetime "max_scheduled_out_to",          :default => '1970-01-01 00:00:00', :null => false
    t.integer  "cents",                                                            :null => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "revenues", :force => true do |t|
    t.integer  "account_to_id", :null => false
    t.integer  "customer_id",   :null => false
    t.string   "memo"
    t.datetime "executed_at",   :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "revenues", ["executed_at"], :name => "index_revenues_on_executed_at"

  create_table "transaction_recipe_template", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.integer  "spill_over_virtual_account_id"
    t.integer  "vendor_id"
    t.integer  "default_inside_account_id",                                        :null => false
    t.integer  "customer_id"
    t.string   "occurs_at"
    t.string   "base_interval"
    t.integer  "num_of_intervals",              :default => 1
    t.date     "starts_on"
    t.date     "ends_on"
    t.boolean  "is_promised"
    t.integer  "current_as_of_hours_prior"
    t.datetime "max_scheduled_out_to",          :default => '1970-01-01 00:00:00', :null => false
    t.integer  "cents",                                                            :null => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "transaction_template", :force => true do |t|
    t.integer  "vendor_id"
    t.integer  "account_from_id"
    t.integer  "account_to_id"
    t.integer  "customer_id"
    t.string   "memo"
    t.integer  "cents"
    t.datetime "executed_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "transaction_template", ["executed_at"], :name => "index_transaction_template_on_executed_at"

  create_table "transfers", :force => true do |t|
    t.integer  "account_from_id", :null => false
    t.integer  "account_to_id",   :null => false
    t.string   "memo"
    t.integer  "cents",           :null => false
    t.datetime "executed_at",     :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "transfers", ["executed_at"], :name => "index_transfers_on_executed_at"

  create_table "vendors", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "virtual_accounts", :force => true do |t|
    t.string   "name",                        :null => false
    t.integer  "primary_spending_account_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "virtual_accounts", ["name"], :name => "index_virtual_accounts_on_name", :unique => true

  create_table "virtual_purchases", :force => true do |t|
    t.integer  "purchase_id",     :null => false
    t.integer  "account_from_id", :null => false
    t.integer  "cents",           :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "virtual_revenues", :force => true do |t|
    t.integer  "revenue_id",    :null => false
    t.integer  "account_to_id", :null => false
    t.integer  "cents",         :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "virtual_transaction_template", :force => true do |t|
    t.integer  "purchase_id"
    t.integer  "revenue_id"
    t.integer  "account_from_id"
    t.integer  "account_to_id"
    t.integer  "cents",           :null => false
    t.datetime "executed_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "virtual_transaction_template", ["executed_at"], :name => "index_virtual_transaction_template_on_executed_at"

  create_table "virtual_transfers", :force => true do |t|
    t.integer  "account_from_id", :null => false
    t.integer  "account_to_id",   :null => false
    t.integer  "cents",           :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
