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

ActiveRecord::Schema.define(:version => 20130613012313) do

  create_table "animals", :force => true do |t|
    t.string "name"
  end

  create_table "animals_farms", :force => true do |t|
    t.integer "farm_id"
    t.integer "animal_id"
    t.decimal "animals_units"
  end

  create_table "commercial_fertilizer_applications", :force => true do |t|
    t.integer  "crop_rotation_id"
    t.integer  "application_date_year"
    t.integer  "application_date_month"
    t.integer  "application_date_day"
    t.decimal  "total_n_applied"
    t.decimal  "total_p_applied"
    t.boolean  "is_incorporated"
    t.integer  "incorporation_date_year"
    t.integer  "incorporation_date_month"
    t.integer  "incorporation_date_day"
    t.decimal  "incorporation_depth"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "counties", :force => true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "fips"
  end

  create_table "crop_categories", :force => true do |t|
    t.string "name"
  end

  create_table "crop_rotations", :force => true do |t|
    t.integer  "crop_id"
    t.integer  "planting_method_id"
    t.decimal  "seeding_rate"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "strip_id"
    t.integer  "plant_date_year"
    t.integer  "plant_date_month"
    t.integer  "plant_date_day"
    t.integer  "end_of_season_year"
    t.integer  "end_of_season_month"
    t.integer  "end_of_season_day"
    t.boolean  "is_cover_crop"
    t.integer  "cover_crop_id"
    t.integer  "cover_crop_planting_method_id"
  end

  create_table "crops", :force => true do |t|
    t.string  "name"
    t.integer "crop_category_id"
  end

  create_table "end_of_season_types", :force => true do |t|
    t.string "name"
  end

  create_table "end_of_seasons", :force => true do |t|
    t.integer  "end_of_season_type_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.integer  "crop_rotation_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "farms", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "tract_number"
    t.string   "farm_notes"
    t.string   "site_name",         :null => false
    t.string   "site_street_1"
    t.string   "site_street_2"
    t.string   "site_city"
    t.string   "site_zip"
    t.integer  "owner_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "site_state_id",     :null => false
    t.integer  "site_county_id",    :null => false
    t.text     "site_description"
    t.text     "coordinates"
    t.decimal  "acres"
    t.integer  "generator_type_id"
  end

  create_table "field_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.decimal  "area"
    t.string   "baseline_load"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "farm_id"
    t.text     "coordinates"
    t.decimal  "acres"
    t.boolean  "tmdl_watershed"
    t.integer  "field_type_id"
    t.text     "notes"
    t.decimal  "acres_from_map"
    t.boolean  "acres_use_map"
    t.decimal  "tile_drainage_depth"
    t.integer  "irrigation_id"
    t.decimal  "fertigation_n"
    t.integer  "p_test_method_id"
    t.decimal  "p_test_value"
    t.decimal  "efficiency"
    t.integer  "watershed_segment_id"
    t.string   "hydrologic_group"
  end

  create_table "generator_types", :force => true do |t|
    t.string "name"
  end

  create_table "grazing_livestocks", :force => true do |t|
    t.integer  "crop_rotation_id"
    t.integer  "start_date_year"
    t.integer  "start_date_month"
    t.integer  "start_date_day"
    t.integer  "end_date_year"
    t.integer  "end_date_month"
    t.integer  "end_date_day"
    t.integer  "animal_id"
    t.decimal  "animal_units"
    t.decimal  "hours_grazed"
    t.boolean  "precision_feeding"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "irrigations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "liquid_unit_types", :force => true do |t|
    t.string "name"
  end

  create_table "livestock", :force => true do |t|
    t.decimal "animal_units"
    t.integer "animal_id"
    t.integer "farm_id"
  end

  create_table "manure_consistencies", :force => true do |t|
    t.string "name"
  end

  create_table "manure_fertilizer_applications", :force => true do |t|
    t.integer  "crop_rotation_id"
    t.integer  "application_date_year"
    t.integer  "application_date_month"
    t.integer  "application_date_day"
    t.integer  "manure_type_id"
    t.integer  "manure_consistency_id"
    t.integer  "liquid_unit_type_id"
    t.decimal  "total_n_concentration"
    t.decimal  "p_concentration"
    t.integer  "p_type_id"
    t.decimal  "application_rate"
    t.decimal  "moisture_content"
    t.boolean  "is_precision_feeding"
    t.boolean  "is_phytase_treatment"
    t.boolean  "is_poultry_litter_treatment"
    t.boolean  "is_incorporated"
    t.integer  "incorporation_date_year"
    t.integer  "incorporation_date_month"
    t.integer  "incorporation_date_day"
    t.decimal  "incorporation_depth"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "manure_type_categories", :force => true do |t|
    t.string "name"
  end

  create_table "manure_types", :force => true do |t|
    t.string  "name"
    t.integer "manure_type_category_id"
  end

  create_table "p_test_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "p_types", :force => true do |t|
    t.string "name"
  end

  create_table "planting_methods", :force => true do |t|
    t.string "name"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "soil_types", :force => true do |t|
    t.string "name"
  end

  create_table "soils", :force => true do |t|
    t.integer  "soil_type_id"
    t.integer  "field_id"
    t.decimal  "percent_clay"
    t.decimal  "percent_sand"
    t.decimal  "percent_silt"
    t.decimal  "bulk_density"
    t.decimal  "organic_carbon"
    t.decimal  "slope"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.decimal  "percent"
    t.integer  "map_unit_key"
    t.string   "component_name"
    t.string   "map_unit_name"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "abbreviation"
  end

  create_table "strips", :force => true do |t|
    t.decimal  "length"
    t.integer  "field_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tillage_operation_types", :force => true do |t|
    t.string "name"
  end

  create_table "tillage_operations", :force => true do |t|
    t.integer  "crop_rotation_id"
    t.integer  "start_date_year"
    t.integer  "start_date_month"
    t.integer  "start_date_day"
    t.integer  "tillage_operation_type_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "approved",               :default => true
    t.datetime "deleted_at"
    t.integer  "user_type_id"
    t.string   "phone"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.string   "org_name"
    t.string   "job_title"
    t.string   "org_street1"
    t.string   "org_street2"
    t.string   "org_city"
    t.integer  "org_state_id"
    t.string   "org_zip"
    t.string   "email",                                    :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_email", :unique => true

  create_table "watershed_segments", :force => true do |t|
    t.string   "key"
    t.string   "description"
    t.string   "hgmr_code"
    t.string   "state_name"
    t.string   "county_name"
    t.integer  "fips"
    t.string   "major_basin"
    t.string   "trib_strat_basin"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
