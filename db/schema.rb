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

ActiveRecord::Schema.define(:version => 20130810005805) do

  create_table "animals", :force => true do |t|
    t.string  "name"
    t.integer "category_id"
    t.decimal "typical_live_weight"
    t.decimal "animals_per_au"
    t.decimal "daily_manure_production_lbs_per_au"
    t.decimal "mortality_rate"
    t.decimal "fraction_p2o5"
    t.decimal "fraction_nh3"
    t.decimal "fraction_org_n"
    t.decimal "fraction_no3"
    t.decimal "fraction_org_p"
    t.decimal "fraction_po4p"
    t.decimal "volatilization_fraction"
    t.decimal "default_nh3_lbs"
    t.decimal "default_org_n_lbs"
    t.decimal "default_org_p_lbs"
    t.decimal "default_po4_lbs"
    t.decimal "storage_loss_fraction"
  end

  create_table "animals_farms", :force => true do |t|
    t.integer "farm_id"
    t.integer "animal_id"
    t.decimal "animals_units"
  end

  create_table "bmp_efficiency_lookups", :force => true do |t|
    t.integer "bmp_type_id"
    t.integer "field_type_id"
    t.string  "hgmr_code"
    t.decimal "n_reduction"
    t.decimal "p_reduction"
    t.decimal "sediment_reduction"
  end

  create_table "bmp_types", :force => true do |t|
    t.string "name"
    t.text   "abbreviation"
  end

  create_table "bmps", :force => true do |t|
    t.integer "field_id"
    t.integer "bmp_type_id"
    t.decimal "acres"
    t.boolean "is_planned"
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
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "strip_id"
    t.integer  "plant_date_year"
    t.integer  "plant_date_month"
    t.integer  "plant_date_day"
    t.integer  "end_of_season_year"
    t.integer  "end_of_season_month"
    t.integer  "end_of_season_day"
    t.boolean  "is_cover_crop",                 :default => false, :null => false
    t.integer  "cover_crop_id"
    t.integer  "cover_crop_planting_method_id"
  end

  create_table "crop_types", :force => true do |t|
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crops", :force => true do |t|
    t.string  "name"
    t.integer "crop_category_id"
    t.integer "code"
  end

  create_table "efficiency_bmps", :force => true do |t|
    t.integer "bmp_type_id"
    t.integer "field_type_id"
    t.string  "hgmr_code"
    t.decimal "nitrogen_efficiency"
    t.decimal "phosphorus_efficiency"
    t.decimal "sediment_efficiency"
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
    t.boolean  "is_harvest_as_silage"
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

  create_table "field_livestocks", :force => true do |t|
    t.integer "field_id"
    t.integer "animal_id"
    t.decimal "quantity"
    t.integer "days_per_year_confined"
    t.decimal "hours_per_day_confined"
    t.decimal "n_excreted"
    t.decimal "p205_excreted"
    t.decimal "total_manure"
    t.decimal "average_weight"
  end

  create_table "field_poultry", :force => true do |t|
    t.integer  "field_id"
    t.integer  "poultry_id"
    t.decimal  "quantity"
    t.integer  "flocks_per_year"
    t.decimal  "days_in_growing_cycle"
    t.decimal  "n_excreted"
    t.decimal  "p205_excreted"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "field_type_bmp_types", :force => true do |t|
    t.integer "field_type_id"
    t.integer "bmp_type_id"
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
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "farm_id"
    t.text     "coordinates"
    t.decimal  "acres_from_user"
    t.integer  "field_type_id"
    t.text     "notes"
    t.decimal  "acres_from_map"
    t.boolean  "is_acres_from_map"
    t.decimal  "tile_drainage_depth"
    t.integer  "irrigation_id"
    t.decimal  "fertigation_n"
    t.decimal  "p_test_value"
    t.decimal  "efficiency"
    t.integer  "watershed_segment_id"
    t.boolean  "is_forest_buffer"
    t.decimal  "forest_buffer_average_width"
    t.decimal  "forest_buffer_length"
    t.boolean  "is_forest_buffer_planned"
    t.boolean  "is_grass_buffer"
    t.decimal  "grass_buffer_average_width"
    t.decimal  "grass_buffer_length"
    t.boolean  "is_grass_buffer_planned"
    t.boolean  "is_wetland"
    t.decimal  "wetland_area"
    t.decimal  "wetland_treated_area"
    t.boolean  "is_wetland_planned"
    t.boolean  "is_streambank_restoration"
    t.decimal  "streambank_restoration_length"
    t.boolean  "is_streambank_restoration_planned"
    t.integer  "crop_type_id"
    t.boolean  "is_pasture_adjacent_to_stream"
    t.boolean  "is_streambank_fencing_in_place"
    t.decimal  "distance_fence_stream"
    t.decimal  "fence_length"
    t.integer  "vegetation_type_fence_stream_id"
    t.integer  "livestock_input_method_id"
    t.boolean  "is_livestock_animal_waste_management_system"
    t.boolean  "is_livestock_mortality_composting"
    t.boolean  "is_livestock_plastic_permeable_lagoon_cover"
    t.boolean  "is_livestock_phytase"
    t.boolean  "is_livestock_dairy_precision_feeding"
    t.boolean  "is_livestock_barnyard_runoff_controls"
    t.boolean  "is_livestock_water_control_structure"
    t.boolean  "is_livestock_treatment_wetland"
    t.boolean  "is_poultry_animal_waste_management_system"
    t.boolean  "is_poultry_mortality_composting"
    t.boolean  "is_poultry_biofilters"
    t.boolean  "is_poultry_vegetated_environmental_buffer"
    t.boolean  "is_poultry_phytase"
    t.boolean  "is_poultry_heavy_use_pads"
    t.boolean  "is_poultry_barnyard_runoff_controls"
    t.boolean  "is_poultry_water_control_structure"
    t.boolean  "is_poultry_treatment_wetland"
    t.boolean  "is_poultry_litter_treatment"
    t.boolean  "is_livestock_implemented_nutrient_plan"
    t.boolean  "is_livestock_implemented_soil_water_plan"
    t.boolean  "is_livestock_properly_sized_maintained"
    t.integer  "tmdl_id"
    t.integer  "soil_p_extractant_id"
    t.boolean  "is_field_adjacent_water"
    t.boolean  "is_fertilizer_application_setback"
    t.decimal  "fertilizer_application_setback_average_width"
    t.decimal  "fertilizer_application_setback_length"
    t.boolean  "is_fertilizer_application_setback_planned"
    t.text     "planned_management_details"
    t.string   "watershed_name"
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
    t.integer  "days_grazed"
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

  create_table "livestock_input_methods", :force => true do |t|
    t.string "name"
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
    t.decimal "p_fraction"
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

  create_table "soil_p_extractants", :force => true do |t|
    t.string  "name"
    t.string  "unit"
    t.decimal "m_value"
    t.decimal "p_value"
    t.integer "formula_code"
    t.integer "soil_test_laboratory_id"
    t.decimal "h_value"
    t.decimal "g_value"
  end

  create_table "soil_test_laboratories", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
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
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.decimal  "percent"
    t.integer  "map_unit_key"
    t.string   "component_name"
    t.string   "map_unit_name"
    t.string   "hydrologic_group"
    t.string   "map_unit_symbol"
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

  create_table "tmdls", :force => true do |t|
    t.string  "name"
    t.decimal "total_n"
    t.decimal "total_p"
    t.integer "code",    :limit => 8
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

  create_table "vegetation_types", :force => true do |t|
    t.string "name"
  end

  create_table "watershed_segments", :force => true do |t|
    t.string   "key"
    t.string   "description"
    t.string   "hgmr_code"
    t.string   "state_name"
    t.string   "county_name"
    t.integer  "fips"
    t.string   "major_basin"
    t.string   "trib_strat_basin"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.decimal  "total_n_forest"
    t.decimal  "total_n_hyo"
    t.decimal  "total_n_trp"
    t.decimal  "total_p_forest"
    t.decimal  "total_p_hyo"
    t.decimal  "total_p_trp"
    t.decimal  "total_sediment_forest"
    t.decimal  "total_sediment_hyo"
    t.decimal  "total_sediment_trp"
    t.decimal  "n_delivery_factor"
    t.decimal  "p_delivery_factor"
    t.decimal  "sediment_delivery_total"
    t.decimal  "n_crop_baseline"
    t.decimal  "n_pasture_baseline"
    t.decimal  "n_hay_baseline"
    t.decimal  "p_crop_baseline"
    t.decimal  "p_pasture_baseline"
    t.decimal  "p_hay_baseline"
    t.decimal  "sediment_crop_baseline"
    t.decimal  "sediment_pasture_baseline"
    t.decimal  "sediment_hay_baseline"
    t.decimal  "n_adjust"
    t.decimal  "p_adjust"
    t.decimal  "sediment_adjust"
    t.decimal  "cafo_eos_sediment"
    t.decimal  "cafo_n_rf"
    t.decimal  "cafo_p_rf"
  end

end
