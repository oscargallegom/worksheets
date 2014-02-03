class ChangeTableDataTypes < ActiveRecord::Migration
    def self.up
    change_table :animals_farms do |t|
      t.change :animals_units, :float
    end

    change_table :bmp_efficiency_lookups do |t|
      t.change :n_reduction, :float
      t.change :p_reduction, :float
      t.change :sediment_reduction, :float
    end

    change_table :commercial_fertilizer_applications do |t|
      t.change :total_n_applied, :float
      t.change :total_p_applied, :float
      t.change :incorporation_depth, :float
    end

    change_table :crop_rotations do |t|
      t.change :seeding_rate, :float
    end

    change_table :efficiency_bmps do |t|
      t.change :nitrogen_efficiency, :float
      t.change :phosphorus_efficiency, :float
      t.change :sediment_efficiency, :float
    end

    change_table :farms do |t|
      t.change :acres, :float
    end

    change_table :field_livestocks do |t|
      t.change :quantity, :float
      t.change :hours_per_day_confined, :float
      t.change :n_excreted, :float
      t.change :p205_excreted, :float
      t.change :average_weight, :float
    end

    change_table :field_poultry do |t|
      t.change :quantity, :float
      t.change :days_in_growing_cycle, :float
      t.change :n_excreted, :float
      t.change :p205_excreted, :float
    end

    change_table :fields do |t|
      t.change :area, :float
      t.change :acres_from_user, :float
      t.change :acres_from_map, :float
      t.change :tile_drainage_depth, :float
      t.change :fertigation_n, :float
      t.change :p_test_value, :float
      t.change :efficiency, :float
      t.change :forest_buffer_average_width, :float
      t.change :forest_buffer_length, :float
      t.change :grass_buffer_average_width, :float
      t.change :grass_buffer_length, :float
      t.change :wetland_area, :float
      t.change :wetland_treated_area, :float
      t.change :streambank_restoration_length, :float
      t.change :distance_fence_stream, :float
      t.change :fence_length, :float
      t.change :fertilizer_application_setback_average_width, :float
      t.change :fertilizer_application_setback_length, :float
      t.change :other_land_use_conversion_acres, :float
      t.change :forest_buffer_average_width_future, :float
      t.change :forest_buffer_length_future, :float
      t.change :wetland_area_future, :float
      t.change :wetland_treated_area_future, :float
      t.change :streambank_restoration_length_future, :float
      t.change :distance_fence_stream_future, :float
      t.change :fertilizer_application_setback_average_width_future, :float
      t.change :fertilizer_application_setback_length_future, :float
      t.change :is_fertilizer_application_setback_planned_future, :float
      t.change :other_land_use_conversion_acres_future, :float
      t.change :grass_buffer_average_width_future, :float
      t.change :grass_buffer_length_future, :float
      t.change :slope, :float
      t.change :fence_length_future, :float
    end

    change_table :livestock do |t|
      t.change :animal_units, :float
    end

    change_table :grazing_livestocks do |t|
      t.change :animal_units, :float
      t.change :hours_grazed, :float
    end

    change_table :manure_fertilizer_applications do |t|
      t.change :total_n_concentration, :float
      t.change :p_concentration, :float
      t.change :application_rate, :float
      t.change :moisture_content, :float
      t.change :incorporation_depth, :float
    end

    change_table :manure_types do |t|
      t.change :p_fraction, :float
    end

    change_table :soil_p_extractants do |t|
      t.change :m_value, :float
      t.change :b_value, :float
      t.change :h_value, :float
      t.change :g_value, :float
    end

    change_table :soil_textures do |t|
      t.change :percent_sand, :float
      t.change :percent_silt, :float
      t.change :percent_clay, :float
      t.change :bulk_density, :float
      t.change :organic_carbon, :float
    end

    change_table :soils do |t|
      t.change :percent_clay, :float
      t.change :percent_sand, :float
      t.change :percent_silt, :float
      t.change :organic_carbon, :float
      t.change :slope, :float
      t.change :percent, :float
      t.change :niccdcdpct, :float
    end

    change_table :strips do |t|
      t.change :length, :float
    end

    change_table :tmdls do |t|
      t.change :total_n, :float
      t.change :total_p, :float
    end


    change_table :watershed_segments do |t|
      t.change :total_n_forest, :float
      t.change :total_n_hyo, :float
      t.change :total_n_trp, :float
      t.change :total_p_forest, :float
      t.change :total_p_hyo, :float
      t.change :total_p_trp, :float
      t.change :total_sediment_forest, :float
      t.change :total_sediment_hyo, :float
      t.change :total_sediment_trp, :float
      t.change :n_delivery_factor, :float
      t.change :p_delivery_factor, :float
      t.change :sediment_delivery_factor, :float
      t.change :n_crop_baseline, :float
      t.change :n_pasture_baseline, :float
      t.change :n_hay_baseline, :float
      t.change :p_crop_baseline, :float
      t.change :p_pasture_baseline, :float
      t.change :p_hay_baseline, :float
      t.change :sediment_crop_baseline, :float
      t.change :sediment_pasture_baseline, :float
      t.change :sediment_hay_baseline, :float
      t.change :n_crop_adjust, :float
      t.change :p_crop_adjust, :float
      t.change :sediment_crop_adjust, :float
      t.change :cafo_eos_sediment, :float
      t.change :cafo_n_rf, :float
      t.change :cafo_p_rf, :float
      t.change :n_hay_adjust, :float
      t.change :p_hay_adjust, :float
      t.change :sediment_hay_adjust, :float
      t.change :n_pasture_adjust, :float
      t.change :p_pasture_adjust, :float
      t.change :sediment_pasture_adjust, :float
    end
  end

  def self.down
    change_table :animals_farms do |t|
      t.change :animals_units, :decimal
    end

    change_table :bmp_efficiency_lookups do |t|
      t.change :n_reduction, :decimal
      t.change :p_reduction, :decimal
      t.change :sediment_reduction, :decimal
    end

    change_table :commercial_fertilizer_applications do |t|
      t.change :total_n_applied, :decimal
      t.change :total_p_applied, :decimal
      t.change :incorporation_depth, :decimal
    end

    change_table :crop_rotations do |t|
      t.change :seeding_rate, :decimal
    end

    change_table :efficiency_bmps do |t|
      t.change :nitrogen_efficiency, :decimal
      t.change :phosphorus_efficiency, :decimal
      t.change :sediment_efficiency, :decimal
    end

    change_table :farms do |t|
      t.change :acres, :decimal
    end

    change_table :field_livestocks do |t|
      t.change :quantity, :decimal
      t.change :hours_per_day_confined, :decimal
      t.change :n_excreted, :decimal
      t.change :p205_excreted, :decimal
      t.change :average_weight, :decimal
    end

    change_table :field_poultry do |t|
      t.change :quantity, :decimal
      t.change :days_in_growing_cycle, :decimal
      t.change :n_excreted, :decimal
      t.change :p205_excreted, :decimal
    end

    change_table :fields do |t|
      t.change :area, :decimal
      t.change :acres_from_user, :decimal
      t.change :acres_from_map, :decimal
      t.change :tile_drainage_depth, :decimal
      t.change :fertigation_n, :decimal
      t.change :p_test_value, :decimal
      t.change :efficiency, :decimal
      t.change :forest_buffer_average_width, :decimal
      t.change :forest_buffer_length, :decimal
      t.change :grass_buffer_average_width, :decimal
      t.change :grass_buffer_length, :decimal
      t.change :wetland_area, :decimal
      t.change :wetland_treated_area, :decimal
      t.change :streambank_restoration_length, :decimal
      t.change :distance_fence_stream, :decimal
      t.change :fence_length, :decimal
      t.change :fertilizer_application_setback_average_width, :decimal
      t.change :fertilizer_application_setback_length, :decimal
      t.change :other_land_use_conversion_acres, :decimal
      t.change :forest_buffer_average_width_future, :decimal
      t.change :forest_buffer_length_future, :decimal
      t.change :wetland_area_future, :decimal
      t.change :wetland_treated_area_future, :decimal
      t.change :streambank_restoration_length_future, :decimal
      t.change :distance_fence_stream_future, :decimal
      t.change :fertilizer_application_setback_average_width_future, :decimal
      t.change :fertilizer_application_setback_length_future, :decimal
      t.change :is_fertilizer_application_setback_planned_future, :decimal
      t.change :other_land_use_conversion_acres_future, :decimal
      t.change :grass_buffer_average_width_future, :decimal
      t.change :grass_buffer_length_future, :decimal
      t.change :slope, :decimal
      t.change :fence_length_future, :decimal
    end

    change_table :livestock do |t|
      t.change :animal_units, :decimal
    end

    change_table :grazing_livestocks do |t|
      t.change :animal_units, :decimal
      t.change :hours_grazed, :decimal
    end

    change_table :manure_fertilizer_applications do |t|
      t.change :total_n_concentration, :decimal
      t.change :p_concentration, :decimal
      t.change :application_rate, :decimal
      t.change :moisture_content, :decimal
      t.change :incorporation_depth, :decimal
    end

    change_table :manure_types do |t|
      t.change :p_fraction, :decimal
    end

    change_table :soil_p_extractants do |t|
      t.change :m_value, :decimal
      t.change :b_value, :decimal
      t.change :h_value, :decimal
      t.change :g_value, :decimal
    end

    change_table :soil_textures do |t|
      t.change :percent_sand, :decimal
      t.change :percent_silt, :decimal
      t.change :percent_clay, :decimal
      t.change :bulk_density, :decimal
      t.change :organic_carbon, :decimal
    end

    change_table :soils do |t|
      t.change :percent_clay, :decimal
      t.change :percent_sand, :decimal
      t.change :percent_silt, :decimal
      t.change :organic_carbon, :decimal
      t.change :slope, :decimal
      t.change :percent, :decimal
      t.change :niccdcdpct, :decimal
    end

    change_table :strips do |t|
      t.change :length, :decimal
    end

    change_table :tmdls do |t|
      t.change :total_n, :decimal
      t.change :total_p, :decimal
    end


    change_table :watershed_segments do |t|
      t.change :total_n_forest, :decimal
      t.change :total_n_hyo, :decimal
      t.change :total_n_trp, :decimal
      t.change :total_p_forest, :decimal
      t.change :total_p_hyo, :decimal
      t.change :total_p_trp, :decimal
      t.change :total_sediment_forest, :decimal
      t.change :total_sediment_hyo, :decimal
      t.change :total_sediment_trp, :decimal
      t.change :n_delivery_factor, :decimal
      t.change :p_delivery_factor, :decimal
      t.change :sediment_delivery_factor, :decimal
      t.change :n_crop_baseline, :decimal
      t.change :n_pasture_baseline, :decimal
      t.change :n_hay_baseline, :decimal
      t.change :p_crop_baseline, :decimal
      t.change :p_pasture_baseline, :decimal
      t.change :p_hay_baseline, :decimal
      t.change :sediment_crop_baseline, :decimal
      t.change :sediment_pasture_baseline, :decimal
      t.change :sediment_hay_baseline, :decimal
      t.change :n_crop_adjust, :decimal
      t.change :p_crop_adjust, :decimal
      t.change :sediment_crop_adjust, :decimal
      t.change :cafo_eos_sediment, :decimal
      t.change :cafo_n_rf, :decimal
      t.change :cafo_p_rf, :decimal
      t.change :n_hay_adjust, :decimal
      t.change :p_hay_adjust, :decimal
      t.change :sediment_hay_adjust, :decimal
      t.change :n_pasture_adjust, :decimal
      t.change :p_pasture_adjust, :decimal
      t.change :sediment_pasture_adjust, :decimal
    end
  end
end