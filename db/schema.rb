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

ActiveRecord::Schema.define(:version => 20150522161358) do

  create_table "animals", :force => true do |t|
    t.string  "name"
    t.integer "category_id"
    t.float   "typical_live_weight"
    t.float   "animals_per_au"
    t.float   "daily_manure_production_lbs_per_au"
    t.float   "mortality_rate"
    t.float   "fraction_p2o5"
    t.float   "fraction_nh3"
    t.float   "fraction_org_n"
    t.float   "fraction_no3"
    t.float   "fraction_org_p"
    t.float   "fraction_po4p"
    t.float   "volatilization_fraction"
    t.float   "default_nh3_lbs"
    t.float   "default_org_n_lbs"
    t.float   "default_org_p_lbs"
    t.float   "default_po4_lbs"
    t.float   "storage_loss_fraction"
  end

  create_table "animals_farms", :force => true do |t|
    t.float   "animals_units"
    t.integer "farm_id"
    t.integer "animal_id"
  end

  create_table "animals_projects", :id => false, :force => true do |t|
    t.integer "farm_id"
    t.integer "animal_id"
  end

  create_table "bmp_efficiency_lookups", :force => true do |t|
    t.integer "bmp_type_id"
    t.integer "field_type_id"
    t.string  "hgmr_code"
    t.float   "n_reduction"
    t.float   "p_reduction"
    t.float   "sediment_reduction"
  end

  create_table "bmp_types", :force => true do |t|
    t.string "name"
    t.text   "abbreviation"
  end

  create_table "bmps", :force => true do |t|
    t.integer "field_id"
    t.integer "bmp_type_id"
    t.boolean "is_planned"
  end

  create_table "commercial_fertilizer_applications", :force => true do |t|
    t.integer  "crop_rotation_id"
    t.integer  "application_date_year"
    t.integer  "application_date_month"
    t.integer  "application_date_day"
    t.float    "total_n_applied"
    t.float    "total_p_applied"
    t.boolean  "is_incorporated"
    t.integer  "incorporation_date_year"
    t.integer  "incorporation_date_month"
    t.integer  "incorporation_date_day"
    t.float    "incorporation_depth"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "p_type_id"
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
    t.float    "seeding_rate"
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
    t.integer  "cover_crop_plant_date_year"
    t.integer  "cover_crop_plant_date_month"
    t.integer  "cover_crop_plant_date_day"
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
    t.float   "nitrogen_efficiency"
    t.float   "phosphorus_efficiency"
    t.float   "sediment_efficiency"
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
    t.string   "site_name"
    t.string   "site_street_1"
    t.string   "site_street_2"
    t.string   "site_city"
    t.string   "site_zip"
    t.integer  "owner_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "site_state_id"
    t.integer  "site_county_id"
    t.text     "site_description"
    t.text     "coordinates"
    t.float    "acres"
    t.integer  "generator_type_id"
    t.string   "application_name"
    t.string   "weather"
  end

  create_table "field_livestocks", :force => true do |t|
    t.integer "field_id"
    t.integer "animal_id"
    t.float   "quantity"
    t.integer "days_per_year_confined"
    t.float   "hours_per_day_confined"
    t.float   "n_excreted"
    t.float   "p205_excreted"
    t.float   "total_manure"
    t.float   "average_weight"
  end

  create_table "field_poultry", :force => true do |t|
    t.integer  "field_id"
    t.integer  "animal_id"
    t.float    "quantity"
    t.integer  "flocks_per_year"
    t.float    "days_in_growing_cycle"
    t.float    "n_excreted"
    t.float    "p205_excreted"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "poultry_id"
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
    t.float    "area"
    t.string   "baseline_load"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.text     "coordinates"
    t.float    "acres_from_user"
    t.integer  "field_type_id"
    t.text     "notes"
    t.float    "acres_from_map"
    t.boolean  "is_acres_from_map"
    t.float    "tile_drainage_depth"
    t.integer  "irrigation_id"
    t.float    "fertigation_n"
    t.float    "p_test_value"
    t.float    "efficiency"
    t.integer  "watershed_segment_id"
    t.boolean  "is_forest_buffer"
    t.float    "forest_buffer_average_width"
    t.float    "forest_buffer_length"
    t.boolean  "is_forest_buffer_planned"
    t.boolean  "is_grass_buffer"
    t.float    "grass_buffer_average_width"
    t.float    "grass_buffer_length"
    t.boolean  "is_grass_buffer_planned"
    t.boolean  "is_wetland"
    t.float    "wetland_area"
    t.float    "wetland_treated_area"
    t.boolean  "is_wetland_planned"
    t.boolean  "is_streambank_restoration"
    t.float    "streambank_restoration_length"
    t.boolean  "is_streambank_restoration_planned"
    t.integer  "crop_type_id"
    t.boolean  "is_pasture_adjacent_to_stream"
    t.boolean  "is_streambank_fencing_in_place"
    t.float    "distance_fence_stream"
    t.float    "fence_length"
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
    t.boolean  "is_fertilizer_application_setback"
    t.float    "fertilizer_application_setback_average_width"
    t.float    "fertilizer_application_setback_length"
    t.boolean  "is_fertilizer_application_setback_planned"
    t.text     "planned_management_details"
    t.string   "watershed_name"
    t.string   "tmdl_va"
    t.text     "exclusion_description"
    t.float    "other_land_use_conversion_acres"
    t.integer  "other_land_use_conversion_vegetation_type_id"
    t.boolean  "is_other_land_use_conversion_planned"
    t.boolean  "is_forest_buffer_future"
    t.float    "forest_buffer_average_width_future"
    t.float    "forest_buffer_length_future"
    t.boolean  "is_forest_buffer_planned_future"
    t.boolean  "is_grass_buffer_future"
    t.boolean  "is_grass_buffer_planned_future"
    t.boolean  "is_wetland_future"
    t.float    "wetland_area_future"
    t.float    "wetland_treated_area_future"
    t.boolean  "is_wetland_planned_future"
    t.boolean  "is_streambank_restoration_future"
    t.float    "streambank_restoration_length_future"
    t.boolean  "is_streambank_restoration_planned_future"
    t.boolean  "is_streambank_fencing_in_place_future"
    t.float    "distance_fence_stream_future"
    t.integer  "vegetation_type_fence_stream_id_future"
    t.text     "planned_management_details_future"
    t.boolean  "is_fertilizer_application_setback_future"
    t.float    "fertilizer_application_setback_average_width_future"
    t.float    "fertilizer_application_setback_length_future"
    t.float    "is_fertilizer_application_setback_planned_future"
    t.text     "exclusion_description_future"
    t.float    "other_land_use_conversion_acres_future"
    t.integer  "other_land_use_conversion_vegetation_type_id_future"
    t.boolean  "is_other_land_use_conversion_planned_future"
    t.float    "grass_buffer_average_width_future"
    t.float    "grass_buffer_length_future"
    t.boolean  "is_livestock_animal_waste_management_system_future"
    t.boolean  "is_livestock_mortality_composting_future"
    t.boolean  "is_livestock_plastic_permeable_lagoon_cover_future"
    t.boolean  "is_livestock_phytase_future"
    t.boolean  "is_livestock_dairy_precision_feeding_future"
    t.boolean  "is_livestock_barnyard_runoff_controls_future"
    t.boolean  "is_livestock_water_control_structure_future"
    t.boolean  "is_livestock_treatment_wetland_future"
    t.boolean  "is_poultry_animal_waste_management_system_future"
    t.boolean  "is_poultry_mortality_composting_future"
    t.boolean  "is_poultry_biofilters_future"
    t.boolean  "is_poultry_vegetated_environmental_buffer_future"
    t.boolean  "is_poultry_phytase_future"
    t.boolean  "is_poultry_heavy_use_pads_future"
    t.boolean  "is_poultry_barnyard_runoff_controls_future"
    t.boolean  "is_poultry_water_control_structure_future"
    t.boolean  "is_poultry_treatment_wetland_future"
    t.boolean  "is_poultry_litter_treatment_future"
    t.integer  "soil_texture_id"
    t.float    "slope"
    t.text     "ntt_xml_current"
    t.text     "ntt_xml_future"
    t.float    "fence_length_future"
    t.integer  "farm_id"
    t.string   "segment_id"
    t.float    "current_total_n"
    t.float    "current_sediment_organic_n"
    t.float    "current_soluble_n"
    t.float    "tile_drained_n"
    t.float    "current_total_p"
    t.float    "current_sediment_organic_p"
    t.float    "current_soluble_p"
    t.boolean  "hel_soils"
    t.text     "totals"
  end

  create_table "future_bmps", :force => true do |t|
    t.integer "field_id"
    t.integer "bmp_type_id"
    t.boolean "is_planned"
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
    t.float    "animal_units"
    t.float    "hours_grazed"
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
    t.float   "animal_units"
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
    t.float    "total_n_concentration"
    t.float    "p_concentration"
    t.integer  "p_type_id"
    t.float    "application_rate"
    t.float    "moisture_content"
    t.boolean  "is_precision_feeding"
    t.boolean  "is_phytase_treatment"
    t.boolean  "is_poultry_litter_treatment"
    t.boolean  "is_incorporated"
    t.integer  "incorporation_date_year"
    t.integer  "incorporation_date_month"
    t.integer  "incorporation_date_day"
    t.float    "incorporation_depth"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "manure_type_categories", :force => true do |t|
    t.string "name"
  end

  create_table "manure_types", :force => true do |t|
    t.string  "name"
    t.integer "manure_type_category_id"
    t.float   "p_fraction"
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
    t.float   "m_value"
    t.float   "b_value"
    t.integer "formula_code"
    t.integer "soil_test_laboratory_id"
    t.float   "h_value"
    t.float   "g_value"
  end

  create_table "soil_test_laboratories", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
  end

  create_table "soil_textures", :force => true do |t|
    t.string "name"
    t.float  "percent_sand"
    t.float  "percent_silt"
    t.float  "percent_clay"
    t.float  "bulk_density"
    t.float  "organic_carbon"
  end

  create_table "soil_types", :force => true do |t|
    t.string "name"
  end

  create_table "soils", :force => true do |t|
    t.integer  "soil_type_id"
    t.integer  "field_id"
    t.float    "percent_clay"
    t.float    "percent_sand"
    t.float    "percent_silt"
    t.float    "bulk_density"
    t.float    "organic_carbon"
    t.float    "slope"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.float    "percent"
    t.integer  "map_unit_key"
    t.string   "map_unit_name"
    t.string   "hydrologic_group"
    t.string   "map_unit_symbol"
    t.float    "niccdcdpct"
    t.string   "component_name"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "abbreviation"
  end

  create_table "strips", :force => true do |t|
    t.float    "length"
    t.integer  "field_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_future",  :default => false
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
    t.float   "total_n"
    t.float   "total_p"
    t.integer "code",    :limit => 255
  end

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
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
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
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
    t.string   "email",                                     :null => false
    t.boolean  "is_debug_mode",          :default => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token"
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
    t.float    "total_n_forest"
    t.float    "total_n_hyo"
    t.float    "total_n_trp"
    t.float    "total_p_forest"
    t.float    "total_p_hyo"
    t.float    "total_p_trp"
    t.float    "total_sediment_forest"
    t.float    "total_sediment_hyo"
    t.float    "total_sediment_trp"
    t.float    "n_delivery_factor"
    t.float    "p_delivery_factor"
    t.float    "sediment_delivery_factor"
    t.float    "n_crop_baseline"
    t.float    "n_pasture_baseline"
    t.float    "n_hay_baseline"
    t.float    "p_crop_baseline"
    t.float    "p_pasture_baseline"
    t.float    "p_hay_baseline"
    t.float    "sediment_crop_baseline"
    t.float    "sediment_pasture_baseline"
    t.float    "sediment_hay_baseline"
    t.float    "n_crop_adjust"
    t.float    "p_crop_adjust"
    t.float    "sediment_crop_adjust"
    t.float    "cafo_eos_sediment"
    t.float    "cafo_n_rf"
    t.float    "cafo_p_rf"
    t.float    "n_hay_adjust"
    t.float    "p_hay_adjust"
    t.float    "sediment_hay_adjust"
    t.float    "n_pasture_adjust"
    t.float    "p_pasture_adjust"
    t.float    "sediment_pasture_adjust"
  end

end
